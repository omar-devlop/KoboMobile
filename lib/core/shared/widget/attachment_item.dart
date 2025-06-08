import 'package:flutter/material.dart';
import 'package:kobo/core/enums/download_status.dart';

class AttachmentItem extends StatefulWidget {
  final String index;
  final String fileName;
  final DownloadStatus downloadStatus;

  const AttachmentItem({
    super.key,
    required this.index,
    required this.fileName,
    required this.downloadStatus,
  });

  @override
  State<AttachmentItem> createState() => _AttachmentItemState();
}

class _AttachmentItemState extends State<AttachmentItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 50,
          color: theme.colorScheme.onPrimary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      alignment: Alignment.center,
                      child: Text(
                        widget.index,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 125,
                      child:
                          widget.downloadStatus == DownloadStatus.downloading
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Downloading file"),
                                  Text(
                                    widget.fileName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              )
                              : Text(
                                widget.fileName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                    ),
                    const Spacer(),
                    if (widget.downloadStatus == DownloadStatus.done)
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                      ),
                    if (widget.downloadStatus == DownloadStatus.hold)
                      const Icon(Icons.pending_actions, color: Colors.grey),
                  ],
                ),
              ),
              const Spacer(flex: 4),
              widget.downloadStatus == DownloadStatus.downloading
                  ? LinearProgressIndicator(
                    minHeight: 1,
                    color: theme.colorScheme.primary,
                  )
                  : const SizedBox(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
