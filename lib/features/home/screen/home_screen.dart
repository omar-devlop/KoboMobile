import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/shared/widget/retry_widget.dart';
import 'package:kobo/core/shared/widget/shaded_widgets/shaded_forms_list.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/shared/models/kobo_user.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/features/home/bloc/kobo_forms_cubit.dart';
import 'package:kobo/features/home/widget/kobo_drawer.dart';
import 'package:kobo/features/home/widget/kobo_form_card.dart';
import 'package:kobo/features/notifications/bloc/notifications_cubit.dart';
import 'package:kobo/main.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> reFetchForms() async {
    BlocProvider.of<KoboformsCubit>(context).fetchForms();
    BlocProvider.of<NotificationsCubit>(context).fetchInAppMessagesList();
  }

  late KoboService koboService;
  late KoboUser koboUser;
  bool _isSearching = false;
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  DateTime? _lastBackPressTime;
  bool _allowPop = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    koboService = getIt<KoboService>();
    koboUser = koboService.user;
    _searchController = TextEditingController();
    analytics.logLogin();
  }

  void onPopInvokedWithResult(bool didPop, dynamic result) {
    final scaffold = _scaffoldKey.currentState;
    if (scaffold?.isDrawerOpen == true) {
      context.pop();
      return;
    }

    if (_isSearching) {
      _searchController.clear();
      setState(() {
        _isSearching = false;
      });
      return;
    }

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
    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: !_isSearching ? const KoboDrawer() : null,
        appBar:
            _isSearching
                ? AppBar(
                  title: Center(
                    child: TextField(
                      style: TextStyle(color: theme.colorScheme.secondary),
                      focusNode: _focusNode,
                      controller: _searchController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _isSearching = false;
                            if (!mounted) return;
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                        prefixIcon: IconButton(
                          onPressed: () {
                            if (!mounted) return;
                            setState(() {});
                          },
                          icon: const Icon(Icons.search),
                        ),
                        hintText: context.tr('search'),
                      ),
                      onChanged: (value) {
                        if (!mounted) return;
                        setState(() {});
                      },
                    ),
                  ),
                )
                : AppBar(
                  title: Text(
                    context.tr('hi_text', args: [koboUser.extraDetails.name]),
                  ),
                  actions: [
                    BlocBuilder<NotificationsCubit, NotificationsState>(
                      builder: (context, state) {
                        return state.when(
                          loading:
                              () => Skeletonizer(
                                enabled: true,
                                child: IconButton(
                                  tooltip: context.tr('notifications'),
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                  ),
                                ),
                              ),
                          success:
                              (inAppMessagesList) => IconButton(
                                tooltip: context.tr('notifications'),
                                onPressed:
                                    () => context.pushNamed(
                                      Routes.notificationScreen,
                                      arguments:
                                          context.read<NotificationsCubit>(),
                                    ),
                                icon: Badge(
                                  label: Text(
                                    inAppMessagesList.length.toString(),
                                  ),
                                  isLabelVisible: inAppMessagesList.isNotEmpty,

                                  child: const Icon(
                                    Icons.notifications_outlined,
                                  ),
                                ),
                              ),
                        );
                      },
                    ),

                    IconButton(
                      tooltip: context.tr('search'),
                      onPressed: () {
                        if (!mounted) return;
                        setState(() {
                          _isSearching = true;
                        });

                        HapticFeedback.lightImpact();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          FocusScope.of(context).requestFocus(_focusNode);
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                    const ActionsSpacing(),
                  ],
                ),
        body: BlocBuilder<KoboformsCubit, KoboformsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: (msg) => const ShadedFormsList(),
              success: (data) {
                if (_isSearching && !_searchController.text.isNullOrEmpty()) {
                  data =
                      data
                          .where(
                            (element) => element.name.toLowerCase().contains(
                              _searchController.text,
                            ),
                          )
                          .toList();
                }

                return data.isEmpty
                    ? Center(child: Text(context.tr('noForm')))
                    : RefreshIndicator(
                      onRefresh: reFetchForms,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 8.0);
                        },
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return KoboFormCard(kForm: data[index]);
                        },
                      ),
                    );
              },
              error:
                  (error) => RetryWidget(errorMsg: error, onTap: reFetchForms),
            );
          },
        ),
      ),
    );
  }
}
