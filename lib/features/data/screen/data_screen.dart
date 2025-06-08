import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/helpers/help_func.dart';
import 'package:kobo/core/kobo_utils/validation_status_tool.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/shared/widget/validation_sheet.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/features/data/bloc/data_cubit.dart';
import 'package:kobo/features/data/widget/flipping_circle.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DataScreen extends StatefulWidget {
  final KoboForm kForm;
  const DataScreen({super.key, required this.kForm});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  late ResponseData responseData;
  late ScrollController _scrollController;
  bool _isLoadingMore = false;
  bool _isSearching = false;
  bool _isSearched = false;
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  Set<int> selectedIds = {};
  bool get _allowPop => selectedIds.isEmpty && !_isSearching;
  SurveyItem? selectedQuestion;

  void fetchData() {
    if (_searchController.text.isEmpty) {
      _isSearched = false;
      context.read<DataCubit>().fetchData();
    } else {
      _isSearched = true;
      String searchField = 'meta/instanceName';
      if (selectedQuestion != null) {
        searchField = selectedQuestion!.xpath;
      }
      context.read<DataCubit>().fetchData(
        additionalQuery: {
          'query':
              '{"$searchField": {"\$regex": ".*${_searchController.text}.*","\$options": "i"}}',
        },
      );
    }
  }

  void _onScroll() {
    if (responseData.results.length < responseData.count &&
        _scrollController.position.pixels >
            0.8 * _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      context.read<DataCubit>().fetchMoreData();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController();
    responseData = ResponseData.empty();
    super.initState();
  }

  void onPopInvokedWithResult(bool didPop, dynamic result) {
    if (_isSearching) {
      setState(() {
        _searchController.clear();
        _isSearching = false;
      });
      if (_isSearched) fetchData();
      return;
    }

    if (selectedIds.isNotEmpty) {
      setState(() {
        selectedIds.clear();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar:
            selectedIds.isNotEmpty
                ? AppBar(
                  leading: IconButton(
                    onPressed: () {
                      if (!mounted) return;
                      setState(() {
                        selectedIds.clear();
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      context.tr('data'),
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding: EdgeInsets.zero,
                    subtitle: Text(
                      context.tr(
                        'selected_submissions',
                        args: [
                          selectedIds.length.toString(),
                          responseData.count.toString(),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  actions: [
                    BlocBuilder<DataCubit, DataState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () => const SizedBox.shrink(),
                          success: (data, isLoadingMore, isUpdating) {
                            return PopupMenuButton<int>(
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.verified),
                                        const ActionsSpacing(),
                                        Text(context.tr('validation')),
                                      ],
                                    ),
                                    onTap: () async {
                                      bool? result = await openValidationSheet(
                                        context,
                                        uid: data.form.uid,
                                        submissionIds: selectedIds.toList(),
                                      );
                                      if (context.mounted && result != null) {
                                        context
                                            .read<DataCubit>()
                                            .reFetchSubmissions(
                                              selectedIds.toList(),
                                            );
                                      }
                                    },
                                  ),
                                ];
                              },
                            );
                          },
                        );
                      },
                    ),
                    const ActionsSpacing(),
                  ],
                )
                : _isSearching
                ? AppBar(
                  automaticallyImplyLeading: false,
                  title: Center(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) => fetchData(),
                      style: TextStyle(color: theme.colorScheme.secondary),
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
                            if (!mounted) return;
                            setState(() {
                              _searchController.clear();
                              _isSearching = false;
                            });
                            if (_isSearched) fetchData();
                          },
                          icon: const Icon(Icons.close),
                        ),
                        prefixIcon: IconButton(
                          onPressed: fetchData,
                          icon: const Icon(Icons.search),
                        ),
                        hintText: context.tr('search'),
                      ),
                    ),
                  ),
                )
                : AppBar(
                  title: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    subtitle: Text(
                      widget.kForm.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      context.tr('data'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  actions: [
                    BlocBuilder<DataCubit, DataState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () => const SizedBox.shrink(),
                          success:
                              (
                                data,
                                isLoadingMore,
                                isUpdating,
                              ) => PopupMenuButton<String>(
                                itemBuilder: (BuildContext ctx) {
                                  List<PopupMenuEntry<String>> itemsList = [
                                    PopupMenuItem<String>(
                                      enabled:
                                          selectedQuestion == null
                                              ? false
                                              : true,
                                      value: 'meta/instanceName',
                                      child: Text(context.tr('instanceName')),
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            selectedQuestion = null;
                                          });
                                        }
                                      },
                                    ),
                                    const PopupMenuDivider(),
                                  ];
                                  itemsList.addAll(
                                    data.questions
                                        .where((q) => !q.type.isGroupOrRepeat)
                                        .map((question) {
                                          return PopupMenuItem<String>(
                                            enabled:
                                                selectedQuestion != question,
                                            value: question.name,
                                            child: Text(
                                              data.getLabel(question.name),
                                            ),
                                            onTap: () {
                                              if (mounted) {
                                                setState(() {
                                                  selectedQuestion = question;
                                                });
                                              }
                                            },
                                          );
                                        }),
                                  );
                                  return itemsList;
                                },
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
        body: BlocConsumer<DataCubit, DataState>(
          listener: (BuildContext _, DataState state) {
            if (state is Success) {
              responseData = state.data.responseData;
              _isLoadingMore = state.isLoadingMore ?? false;
            }
          },
          builder: (_, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading:
                  (msg) => Center(
                    child: Column(
                      spacing: 20.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        Text(
                          msg,
                          style: TextStyle(color: theme.colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
              success: (data, isLoadingMore, isUpdating) {
                List<SubmissionData> submissionList = data.responseData.results;
                if (submissionList.isNullOrEmpty()) {
                  return Center(child: Text(context.tr('noData')));
                } else {
                  return Skeletonizer(
                    enabled: isUpdating == true,
                    child: _buildList(
                      submissionList,
                      data,
                      isLoadingMore,
                      theme,
                      selectedQuestion,
                    ),
                  );
                }
              },
              error: (error) => Center(child: Text('Error: $error')),
            );
          },
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

        floatingActionButton: BlocBuilder<DataCubit, DataState>(
          builder: (context, state) {
            return state.maybeWhen(
              success:
                  (data, isLoadingMore, isUpdating) => FloatingActionButton(
                    onPressed:
                        isLoadingMore == true
                            ? null
                            : () => context.read<DataCubit>().fetchMoreData(),
                    child:
                        isLoadingMore == true
                            ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(),
                            )
                            : const Icon(Icons.download),
                  ),
              orElse: () {
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(
    List<SubmissionData> submissionList,
    KoboFormRepository data,
    bool? isLoadingMore,
    ThemeData theme,
    SurveyItem? selectedQuestion,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: submissionList.length,
            itemBuilder: (_, index) {
              SubmissionData submissionData = submissionList[index];

              final isSelected = selectedIds.contains(submissionData.id);

              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    if (isSelected) {
                      selectedIds.remove(submissionData.id);
                    } else {
                      selectedIds.add(submissionData.id);
                    }
                  });
                },
                onTap: () {
                  if (selectedIds.isNotEmpty) {
                    setState(() {
                      if (isSelected) {
                        selectedIds.remove(submissionData.id);
                      } else {
                        selectedIds.add(submissionData.id);
                      }
                    });
                  } else {
                    context.pushNamed(
                      Routes.submissionScreen,
                      arguments: [data, index, context.read<DataCubit>()],
                    );
                  }
                },
                child: ListTile(
                  selected: isSelected,
                  selectedTileColor: theme.colorScheme.onInverseSurface,
                  leading: FlippingCircle(
                    selected: isSelected,
                    index: index,
                    multiSelectActive: selectedIds.isNotEmpty,
                  ),
                  title: Text(
                    selectedQuestion == null
                        ? submissionData.metaInstanceName
                        : submissionData
                                .data[selectedQuestion.name]
                                ?.fieldValue ??
                            context.tr('na'),
                  ),
                  subtitle:
                      !submissionData.submissionTime.isNullOrEmpty()
                          ? Text(
                            getFormattedTimeAgo(
                              context,
                              submissionData.submissionTime,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          )
                          : null,
                  trailing: getValidationStatusIcon(
                    validationLabel: submissionData.validationStatus?.label,
                  ),
                ),
              );
            },
          ),
        ),
        if (isLoadingMore == true) const LinearProgressIndicator(),
      ],
    );
  }
}
