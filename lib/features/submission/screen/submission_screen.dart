import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/helpers/extensions/safe_index_ext.dart';
import 'package:kobo/core/helpers/help_func.dart';
import 'package:kobo/core/kobo_utils/time_differ.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/services/pdf_service.dart';
import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/core/shared/models/submission_field.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/shared/widget/attachment_container.dart';
import 'package:kobo/core/shared/widget/label_widget.dart';
import 'package:kobo/core/shared/widget/share_sheet.dart';
import 'package:kobo/core/shared/widget/language_selector.dart';
import 'package:kobo/core/shared/widget/time_widget.dart';
import 'package:kobo/core/shared/widget/validation_sheet.dart';
import 'package:kobo/core/shared/widget/validation_widget.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/features/data/bloc/data_cubit.dart';
import 'package:kobo/features/submission/widget/attachments_scroll_view.dart';
import 'package:kobo/features/submission/widget/barcode_container.dart';
import 'package:kobo/features/submission/widget/field_container.dart';
import 'package:kobo/features/submission/widget/kobo_page_indicator.dart';
import 'package:kobo/features/submission/widget/map_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubmissionScreen extends StatefulWidget {
  final KoboFormRepository survey;
  final int submissionIndex;

  const SubmissionScreen({
    super.key,
    required this.survey,
    required this.submissionIndex,
  });

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  late KoboFormRepository survey;
  late ResponseData responseData;
  late PageController pageController;

  double _lastScrollOffset = 0.0;

  int selectedLangIndex = 1;
  int submissionIndex = 0;
  bool showXML = false;

  bool _isLoadingMore = false;

  @override
  void initState() {
    survey = widget.survey;
    submissionIndex = widget.submissionIndex;
    responseData = survey.responseData;
    if ((submissionIndex + 1) == survey.responseData.results.length) {
      _isLoadingMore = true;
      context.read<DataCubit>().fetchMoreData();
    }
    pageController = PageController(initialPage: submissionIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer<DataCubit, DataState>(
      listener: (context, state) {
        if (state is Success) {
          responseData = state.data.responseData;
          _isLoadingMore = state.isLoadingMore ?? false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,

            title: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(survey.form.name, overflow: TextOverflow.ellipsis),
              contentPadding: EdgeInsets.zero,
              subtitle: Text(
                context.tr(
                  'progress_text',
                  args: [
                    '${submissionIndex + 1}',
                    '${survey.responseData.count}',
                    '${survey.responseData.results.length}',
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            actions: [
              SurveyLanguageSelector(
                survey: survey,
                selectedLangIndex: selectedLangIndex,
                extraItems: [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        const Icon(Icons.share),
                        const SizedBox(width: 16.0),
                        Text(context.tr('share')),
                      ],
                    ),
                    onTap: () async {
                      openShareSheet(
                        context,
                        title: context.tr("shareSubmission"),
                        survey: survey,
                        submissionIndex: submissionIndex,
                        onTapSharePDF: () async {
                          final data = await getIt<PdfService>()
                              .createSubmissionPdfFile(
                                survey: survey,
                                submissionIndex: submissionIndex,
                                selectedLangIndex: selectedLangIndex,
                                showXml: showXML,
                                cColor: theme.colorScheme.onInverseSurface,
                              );

                          if (data != false) {
                            getIt<PdfService>().savePdfFile(
                              survey.responseData.results[submissionIndex].id
                                  .toString(),
                              data,
                            );
                          }
                        },
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          Icons.data_object,
                          color: showXML ? theme.colorScheme.primary : null,
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          context.tr('showXml'),
                          style:
                              showXML
                                  ? TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  )
                                  : null,
                        ),
                      ],
                    ),
                    onTap: () {
                      if (!mounted) return;
                      setState(() {
                        showXML = !showXML;
                      });
                    },
                  ),
                ],
                onSelected: (val) {
                  if (val == selectedLangIndex) return;
                  if (!mounted) return;
                  selectedLangIndex = val;
                  setState(() {
                    survey.languageIndex = val;
                  });
                },
              ),

              const ActionsSpacing(),
            ],
          ),

          body: Skeletonizer(
            enabled: state.maybeWhen(
              success: (data, isLoadingMore, isUpdating) => isUpdating == true,
              orElse: () => false,
            ),
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: survey.responseData.results.length,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (value) {
                    if (value > (0.8 * survey.responseData.results.length) &&
                        !_isLoadingMore) {
                      context.read<DataCubit>().fetchMoreData();
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },

                  itemBuilder: (ctx, pageIndex) {
                    final scrollController = ScrollController(
                      initialScrollOffset: _lastScrollOffset,
                    );

                    scrollController.addListener(() {
                      _lastScrollOffset = scrollController.offset;
                    });

                    submissionIndex = pageIndex;
                    SubmissionData submissionData =
                        survey.responseData.results[pageIndex];

                    Widget buildMediaField(
                      String title,
                      String fileValue,
                      String questionPath, {
                      String? key,
                    }) {
                      final index = submissionData.attachments.indexWhere(
                        (attachment) =>
                            attachment.questionXpath == questionPath,
                      );

                      final attachment =
                          index != -1
                              ? submissionData.attachments[index]
                              : null;

                      if (attachment == null) {
                        return const SizedBox.shrink();
                      }

                      return FieldContainer(
                        title: title,
                        xmlValue: key,
                        data: fileValue,
                        child: AttachmentContainer(
                          attachment: attachment,
                          showFileName: false,
                          compact: true,
                        ),
                      );
                    }

                    Widget buildBarcodeField(
                      String title,
                      String data, {
                      String? xmlValue,
                    }) {
                      return FieldContainer(
                        title: title,
                        xmlValue: xmlValue,
                        data: data,
                        child: BarcodeContainer(title: title, data: data),
                      );
                    }

                    Widget buildAttachmentsSection() {
                      return FieldContainer(
                        title: context.tr('attachments'),
                        padding: EdgeInsets.zero,
                        child: AttachmentsScrollView(
                          attachmentsValue: submissionData.attachments,
                        ),
                      );
                    }

                    Widget buildTimeWidget() {
                      int startIndex = survey.questions.indexWhere(
                        (element) => element.type == QuestionType.start,
                      );
                      int endIndex = survey.questions.indexWhere(
                        (element) => element.type == QuestionType.end,
                      );
                      String? startTime;
                      String? endTime;

                      if (startIndex >= 0 && endIndex >= 0) {
                        String startName = survey.questions[startIndex].name;
                        String endName = survey.questions[endIndex].name;

                        startTime = submissionData.data[startName]?.fieldValue;
                        endTime = submissionData.data[endName]?.fieldValue;
                      }

                      return TimeWidget(
                        content: calculateTimeDifference(startTime, endTime),
                      );
                    }

                    List<Widget> children = [];

                    children.add(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 8.0,
                          children: [
                            Expanded(
                              child: ValidationWidget(
                                validationStatus:
                                    submissionData.validationStatus,
                              ).tapScale(
                                onTap: () async {
                                  bool? result = await openValidationSheet(
                                    context,
                                    uid: survey.form.uid,
                                    submissionIds: [submissionData.id],
                                  );
                                  if (context.mounted && result != null) {
                                    context
                                        .read<DataCubit>()
                                        .reFetchSubmissions([
                                          submissionData.id,
                                        ]);
                                  }
                                },
                              ),
                            ),
                            buildTimeWidget(),
                          ],
                        ),
                      ),
                    );

                    children.add(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: [
                            LabelWidget(
                              title: submissionData.id.toString(),
                              icon: Icons.key,
                              backgroundColor:
                                  theme.colorScheme.onInverseSurface,
                            ),
                            if (submissionData.submissionTime.isNotEmpty)
                              LabelWidget(
                                title: getFormattedDate(
                                  context,
                                  submissionData.submissionTime,
                                ),
                                icon: Icons.today,
                                backgroundColor:
                                    theme.colorScheme.onInverseSurface,
                              ),
                            if (submissionData.submittedBy.isNotEmpty)
                              LabelWidget(
                                title: submissionData.submittedBy,
                                icon: Icons.person,
                                backgroundColor:
                                    theme.colorScheme.onInverseSurface,
                              ),
                            if (submissionData.attachments.isNotEmpty)
                              LabelWidget(
                                title:
                                    '${submissionData.attachments.length} ${context.tr('attachments')}',
                                icon: Icons.attachment,
                                backgroundColor:
                                    theme.colorScheme.onInverseSurface,
                              ),
                            if (!submissionData.geolocation.contains(null))
                              LabelWidget(
                                title: submissionData.geolocation.toString(),
                                icon: Icons.location_pin,
                                backgroundColor:
                                    theme.colorScheme.onInverseSurface,
                              ),
                          ],
                        ),
                      ),
                    );

                    for (
                      int index = 0;
                      index < survey.questions.length;
                      index++
                    ) {
                      final SurveyItem question = survey.questions[index];
                      SubmissionField? entry =
                          submissionData.data[question.name];
                      String questionLabel = survey.interpolate(
                        question.labels.getIndexOrFirst(selectedLangIndex),
                        submissionData,
                      );
                      switch (question.type) {
                        case QuestionType.beginGroup:
                        case QuestionType.beginRepeat:
                          children.add(
                            FieldContainer(
                              title: survey.interpolate(
                                question.labels.getIndexOrFirst(
                                  selectedLangIndex,
                                ),
                                submissionData,
                              ),
                              titleStyle: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    question.type == QuestionType.beginRepeat
                                        ? theme.colorScheme.secondary
                                        : theme.colorScheme.primary,
                              ),
                              xmlValue:
                                  showXML
                                      ? survey.questions[index].labels.first
                                      : null,
                            ),
                          );
                          continue;

                        case QuestionType.endGroup:
                        case QuestionType.endRepeat:
                          children.add(const SizedBox.shrink());

                        case QuestionType.image:
                        case QuestionType.audio:
                        case QuestionType.video:
                        case QuestionType.file:
                          if (entry == null) {
                            children.add(const SizedBox.shrink());
                            continue;
                          }
                          children.add(
                            buildMediaField(
                              questionLabel,
                              entry.fieldValue.toString(),
                              entry.fullPath,
                            ),
                          );
                          continue;
                        case QuestionType.barcode:
                          if (entry == null) {
                            children.add(const SizedBox.shrink());
                            continue;
                          }
                          children.add(
                            buildBarcodeField(
                              questionLabel,
                              entry.fieldValue.toString(),
                              xmlValue: showXML ? question.name : null,
                            ),
                          );
                          continue;

                        case QuestionType.geopoint:
                        case QuestionType.geotrace:
                        case QuestionType.geoshape:
                          if (entry == null) {
                            children.add(const SizedBox.shrink());
                            continue;
                          }

                          children.add(
                            MapWidget(
                              title: questionLabel,
                              questionType: question.type,
                              data: entry.fieldValue.toString(),
                              xmlValue: showXML ? question.labels.first : null,
                            ),
                          );

                        default:
                          if (entry == null) {
                            children.add(const SizedBox.shrink());
                            continue;
                          }

                          String dataLabel = '';
                          if (question.type.isSelection) {
                            dataLabel = survey.getMultiLabel(
                              entry.fieldValue.toString(),
                            );
                          } else if (question.type.isFullDate) {
                            dataLabel = getFormattedDate(
                              context,
                              entry.fieldValue.toString(),
                            );
                          } else if (question.type == QuestionType.date ||
                              question.type == QuestionType.today) {
                            dataLabel = getFormattedDate(
                              context,
                              entry.fieldValue.toString(),
                              pattern: 'dd MMM yyyy',
                            );
                          } else if (question.type == QuestionType.time) {
                            dataLabel = getFormattedTime(
                              context,
                              entry.fieldValue.toString(),
                              pattern: 'hh:mm a',
                            );
                          } else {
                            dataLabel = survey.getLabel(
                              entry.fieldValue.toString(),
                            );
                          }
                          children.add(
                            FieldContainer(
                              title: questionLabel,
                              data: dataLabel,
                              xmlValue: showXML ? question.labels.first : null,
                            ),
                          );
                      }
                    }

                    children.add(buildAttachmentsSection());
                    children.add(const SizedBox(height: 48.0));
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      children: children,
                    );
                  },
                ),
                KoboPageIndicator(
                  pageController: pageController,
                  survey: survey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
