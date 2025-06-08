import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/features/deep_search/bloc/deep_search_cubit.dart';

class DeepSearchScreen extends StatefulWidget {
  const DeepSearchScreen({super.key});

  @override
  State<DeepSearchScreen> createState() => _DeepSearchScreenState();
}

class _DeepSearchScreenState extends State<DeepSearchScreen> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  DateTime? _lastBackPressTime;
  bool _allowPop = false;
  void fetchData() =>
      context.read<DeepSearchCubit>().deepSearch(_searchController.text);

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void onPopInvokedWithResult(bool didPop, dynamic result) {
    if (!didPop) {
      final now = DateTime.now();
      final isWarning =
          _lastBackPressTime == null ||
          now.difference(_lastBackPressTime!) > const Duration(seconds: 2);

      if (isWarning) {
        _lastBackPressTime = now;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('confirmExit')),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          _allowPop = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _allowPop = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocBuilder<DeepSearchCubit, DeepSearchState>(
      builder: (context, state) {
        return PopScope(
          canPop: _allowPop || state is Initial,
          onPopInvokedWithResult: onPopInvokedWithResult,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                context.tr('deepSearch'),
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
              actions: [
                state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  success: (forms, searchResults, isSearching, searchingForm) {
                    return isSearching
                        ? const SizedBox(
                          width: 15.0,
                          height: 15.0,
                          child: CircularProgressIndicator(),
                        )
                        : Icon(Icons.done, color: theme.colorScheme.primary);
                  },
                ),
                const ActionsSpacing(),
              ],
            ),
            body: BlocBuilder<DeepSearchCubit, DeepSearchState>(
              builder: (context, state) {
                return state.when(
                  initial: () => searchForm(theme),
                  error: (error) => searchForm(theme),
                  loading: (msg) => loadingUI(msg, theme),
                  success: (forms, searchResults, isSearching, searchingForm) {
                    return (!isSearching && searchResults.isEmpty)
                        ? Center(
                          child: Text(
                            context.tr('noData'),
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          itemCount: forms.length + 1,

                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  context.tr(
                                    'search_result_message',
                                    args: [
                                      _searchController.text,
                                      searchResults.values
                                          .fold(
                                            0,
                                            (sum, list) => sum + list.length,
                                          )
                                          .toString(),
                                    ],
                                  ),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              );
                            }
                            index--;
                            KoboForm form = forms[index];
                            bool isSearchingForm =
                                searchingForm?.uid == form.uid;
                            bool hasSearchResults = searchResults.containsKey(
                              form.uid,
                            );

                            return !hasSearchResults
                                ? const SizedBox.shrink()
                                : AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(
                                      width: 2.0,
                                      color:
                                          isSearchingForm
                                              ? theme.colorScheme.primary
                                              : theme
                                                  .colorScheme
                                                  .onInverseSurface,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.shadow
                                            .withAlpha(10),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 6.0,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              form.name,
                                              style: theme.textTheme.titleSmall!
                                                  .copyWith(
                                                    color:
                                                        theme
                                                            .colorScheme
                                                            .secondary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ],
                                      ),

                                      Text(
                                        searchResults[form.uid].isNullOrEmpty()
                                            ? ''
                                            : searchResults[form.uid]!.length
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleLarge!
                                            .copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                              fontFeatures: [
                                                const FontFeature.tabularFigures(),
                                              ],
                                            ),
                                      ),
                                      if (isSearchingForm)
                                        const LinearProgressIndicator(
                                          minHeight: 2.0,
                                        ),
                                    ],
                                  ),
                                ).tapScale(
                                  onTap:
                                      () => context.pushNamed(
                                        Routes.formScreen,
                                        arguments: form,
                                      ),
                                );
                          },
                        );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget searchForm(ThemeData theme) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView(
        children: [
          Icon(
            Icons.manage_search,
            color: theme.colorScheme.primary,
            size: 700.w,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  if (!_searchController.text.isNullOrEmpty())
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(100),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => fetchData(),
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.secondary),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  prefixIcon:
                      _searchController.text.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                            tooltip: context.tr('cancel'),
                            onPressed: () {
                              if (!mounted) return;
                              _searchController.clear();
                              _focusNode.unfocus();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.close,
                              color: theme.colorScheme.error,
                            ),
                          ),
                  suffixIcon: IconButton(
                    tooltip: context.tr('search'),
                    onPressed: () {
                      if (!mounted) return;
                      setState(() {});
                      fetchData();
                    },
                    icon: Icon(
                      Icons.search,
                      color:
                          (_searchController.text.isNullOrEmpty())
                              ? null
                              : theme.colorScheme.primary,
                    ),
                  ),

                  hintText: context.tr('search'),
                ),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ),
          ),
          Text(
            context.tr('deepSearchDescription'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  Center loadingUI(String msg, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        children: [
          const CircularProgressIndicator(),
          Text(msg, style: TextStyle(color: theme.colorScheme.secondary)),
        ],
      ),
    );
  }
}
