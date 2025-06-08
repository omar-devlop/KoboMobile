import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kobo/core/enums/download_status.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/helpers/help_func.dart';
import 'package:kobo/core/services/download_manager.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/attachment.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/core/shared/widget/attachment_item.dart';
import 'package:kobo/core/shared/widget/label_widget.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:share_plus/share_plus.dart';

void openShareSheet(
  BuildContext context, {
  required String title,
  required KoboFormRepository survey,
  required int submissionIndex,
  required Function() onTapSharePDF,
}) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder:
      (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _DraggableSheetContent(
          title: title,
          survey: survey,
          submissionIndex: submissionIndex,
          onTapSharePDF: onTapSharePDF,
        ),
      ),
);

class _DraggableSheetContent extends StatefulWidget {
  final String title;
  final KoboFormRepository survey;
  final int submissionIndex;
  final Function() onTapSharePDF;

  const _DraggableSheetContent({
    required this.title,
    required this.survey,
    required this.submissionIndex,
    required this.onTapSharePDF,
  });
  @override
  State<_DraggableSheetContent> createState() => _DraggableSheetContentState();
}

class _DraggableSheetContentState extends State<_DraggableSheetContent> {
  final _sheetController = DraggableScrollableController();
  double _currentExtent = 0.5;
  late SubmissionData _submissionData;
  List<Attachment> _imageAttachments = [];
  final List<AttachmentItem> _attachmentItems = [];
  final List<XFile> _imageFilesList = [];
  bool _sharing = false;
  bool _sharingPDF = false;

  Future<void> _downloadAttachments() async {
    _imageFilesList.clear();
    for (int index = 0; index < _imageAttachments.length; index++) {
      if (!mounted) return;
      setState(() {
        _attachmentItems[index] = AttachmentItem(
          index: _attachmentItems[index].index,
          fileName: _attachmentItems[index].fileName,
          downloadStatus: DownloadStatus.downloading,
        );
      });
      Attachment imageAttachment = _imageAttachments[index];
      String imgName = imageAttachment.filename.lastAfterSlash;
      String? filePath = await getIt<DownloadManager>().getOrDownloadFile(
        imageAttachment.downloadUrl,
        imgName,
      );

      if (filePath != null) {
        if (!mounted) return;
        setState(() {
          _attachmentItems[index] = AttachmentItem(
            index: _attachmentItems[index].index,
            fileName: _attachmentItems[index].fileName,
            downloadStatus: DownloadStatus.done,
          );
        });
        _imageFilesList.add(
          // make this out side here, now it added only when share pdf and its duplicated when multishare pdf
          XFile(filePath, name: imgName, mimeType: imageAttachment.mimetype),
        );
      }
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    _submissionData =
        widget.survey.responseData.results[widget.submissionIndex];
    _sheetController.addListener(() {
      setState(() {
        _currentExtent = _sheetController.size;
      });
    });
    _imageAttachments = widget.survey.getImageAttachments(
      widget.submissionIndex,
    );
    for (var index = 0; index < _imageAttachments.length; index++) {
      _attachmentItems.add(
        AttachmentItem(
          index: (index + 1).toString(),
          fileName: _imageAttachments[index].filename.lastAfterSlash,
          downloadStatus: DownloadStatus.hold,
        ),
      );
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 1.0,
      snap: true,
      snapSizes: const [0.5, 1.0],
      snapAnimationDuration: const Duration(milliseconds: 100),
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(
              _currentExtent < 0.9
                  ? 24.0
                  : mapValue(
                    _currentExtent,
                    inputMin: 0.9,
                    inputMax: 1.0,
                    outputMin: 24.0,
                    outputMax: 0.0,
                  ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 36.0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    height: 60.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.headlineSmall,
                        ),
                        LabelWidget(
                          title: _submissionData.id.toString(),
                          backgroundColor: theme.colorScheme.onPrimary,
                          forgroundColor: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
                _imageAttachments.isEmpty
                    ? Expanded(
                      child: Center(child: Text(context.tr('noAttachments'))),
                    )
                    : Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _attachmentItems.length,
                        itemBuilder: (context, index) {
                          return _attachmentItems[index];
                        },
                      ),
                    ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 6.0,
                  children: [
                    if (_imageAttachments.isNotEmpty)
                      TextButton(
                        onPressed:
                            _sharing
                                ? null
                                : () async {
                                  if (!mounted) return;
                                  setState(() {
                                    _sharing = true;
                                  });
                                  await _downloadAttachments();
                                  if (!mounted) return;

                                  await SharePlus.instance.share(
                                    ShareParams(files: _imageFilesList),
                                  );
                                  if (!mounted) return;
                                  setState(() {
                                    _sharing = false;
                                  });
                                  if (context.mounted) context.pop();
                                },
                        child: Text(
                          context.plural(
                            'share_images',
                            _imageAttachments.length,
                            args: [_imageAttachments.length.toString()],
                          ),
                        ),
                      ),
                    FilledButton.icon(
                      style:
                          _sharing
                              ? ButtonStyle(
                                foregroundColor: WidgetStatePropertyAll(
                                  theme.colorScheme.onSecondary,
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  theme.colorScheme.secondary,
                                ),
                              )
                              : null,
                      onPressed:
                          _sharing
                              ? null
                              : () async {
                                if (!mounted) return;
                                setState(() {
                                  _sharing = true;
                                });
                                await _downloadAttachments();

                                if (!mounted) return;
                                setState(() {
                                  _sharingPDF = true;
                                });

                                await widget.onTapSharePDF();
                                if (!mounted) return;
                                setState(() {
                                  _sharing = false;
                                  _sharingPDF = false;
                                });
                                if (context.mounted) context.pop();
                              },
                      label: Text(context.tr('createPdf')),
                      icon:
                          _sharingPDF
                              ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              )
                              : const FaIcon(FontAwesomeIcons.filePdf),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
