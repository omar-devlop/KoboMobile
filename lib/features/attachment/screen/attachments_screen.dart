import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/attachment.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/shared/widget/attachment_container.dart';
import 'package:kobo/core/shared/widget/language_selector.dart';
import 'package:kobo/features/attachment/bloc/attachments_cubit.dart';

class AttachmentsScreen extends StatefulWidget {
  final KoboForm kForm;
  const AttachmentsScreen({super.key, required this.kForm});

  @override
  State<AttachmentsScreen> createState() => _AttachmentsScreenState();
}

class _AttachmentsScreenState extends State<AttachmentsScreen> {
  late ResponseData responseData;
  late ScrollController _scrollController;
  bool _isLoadingMore = false;
  int selectedLangIndex = 1;
  String selectedQuestions = '';
  List<SurveyItem> mediaQuestions = [];

  void _onScroll() {
    if (responseData.results.length < responseData.count &&
        _scrollController.position.pixels >
            0.8 * _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      context.read<AttachmentsCubit>().fetchMoreData();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    responseData = ResponseData.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Widget buildAttachments(KoboFormRepository survey, bool? isLoadingMore) {
      // Collect all attachments across every result into one flat list
      var allAttachments =
          survey.responseData.results
              .expand((result) => result.attachments)
              .toList();

      if (selectedQuestions.isNotEmpty) {
        allAttachments =
            allAttachments
                .where((element) => element.questionXpath == selectedQuestions)
                .toList();
      }

      if (allAttachments.isNotEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: allAttachments.length,
                itemBuilder: (context, index) {
                  final Attachment attachment = allAttachments[index];
                  return AttachmentContainer(attachment: attachment);
                },
              ),
            ),
            if (isLoadingMore == true) const LinearProgressIndicator(),
          ],
        );
      }

      return Center(child: Text(context.tr("noAttachments")));
    }

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          subtitle: Text(widget.kForm.name, overflow: TextOverflow.ellipsis),
          contentPadding: EdgeInsets.zero,
          title: Text(
            context.tr('attachments'),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          BlocBuilder<AttachmentsCubit, AttachmentsState>(
            builder: (_, state) {
              return state.maybeWhen(
                success:
                    (survey, isLoadingMore) => Row(
                      children: [
                        if (mediaQuestions.isNotEmpty)
                          Badge(
                            isLabelVisible: selectedQuestions.isNotEmpty,
                            child: PopupMenuButton<String>(
                              initialValue: selectedQuestions,
                              icon: const Icon(Icons.question_answer_outlined),
                              itemBuilder: (BuildContext context) {
                                return [
                                  CheckedPopupMenuItem<String>(
                                    value: '',
                                    checked: selectedQuestions == '',
                                    child: Center(
                                      child: Text(
                                        context.tr('allQuestions'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  ...mediaQuestions.map<
                                    CheckedPopupMenuItem<String>
                                  >((SurveyItem question) {
                                    String questionLabel = survey.getLabel(
                                      question.name,
                                    );
                                    return CheckedPopupMenuItem<String>(
                                      value: question.xpath,
                                      checked:
                                          selectedQuestions == question.xpath,
                                      child: Center(
                                        child: Text(
                                          questionLabel,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }),
                                ];
                              },
                              onSelected: (String item) {
                                if (selectedQuestions == item) return;
                                if (!mounted) return;
                                setState(() {
                                  selectedQuestions = item;
                                });

                                context.read<AttachmentsCubit>().fetchData(
                                  additionalQuery:
                                      item.isEmpty
                                          ? null
                                          : {
                                            'query':
                                                '{"$item": {"\$exists": true}}',
                                          },
                                );
                              },
                            ),
                          ),
                        SurveyLanguageSelector(
                          survey: survey,
                          selectedLangIndex: selectedLangIndex,
                          onSelected: (val) {
                            if (val == selectedLangIndex) return;
                            if (!mounted) return;
                            selectedLangIndex = val;
                            setState(() {
                              survey.languageIndex = val;
                            });
                          },
                        ),
                      ],
                    ),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
          const ActionsSpacing(),
        ],
      ),
      body: BlocConsumer<AttachmentsCubit, AttachmentsState>(
        listener: (context, state) {
          if (state is Success) {
            responseData = state.survey.responseData;
            mediaQuestions =
                context.read<AttachmentsCubit>().getMediaQuestions();
            _isLoadingMore = state.isLoadingMore ?? false;
          }
        },
        builder: (context, state) {
          return state.when(
            success: buildAttachments,
            error: (error) => Center(child: Text(error)),
            loading:
                (msg) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12.0,
                    children: [
                      const CircularProgressIndicator(),
                      Text(
                        msg,
                        style: TextStyle(color: theme.colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

      floatingActionButton: BlocBuilder<AttachmentsCubit, AttachmentsState>(
        builder: (context, state) {
          return state.maybeWhen(
            success:
                (data, isLoadingMore) => FloatingActionButton(
                  onPressed:
                      isLoadingMore == true
                          ? null
                          : () =>
                              context.read<AttachmentsCubit>().fetchMoreData(),
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
    );
  }
}
