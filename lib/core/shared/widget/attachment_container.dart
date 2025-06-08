import 'dart:io' show File;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kobo/core/enums/image_sizes.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/kobo_utils/mimetype_tool.dart';
import 'package:kobo/core/services/download_manager.dart';
import 'package:kobo/core/shared/models/attachment.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/networking/dio_factory.dart';

class AttachmentContainer extends StatefulWidget {
  final Attachment attachment;
  final bool? showFileName;
  final bool? compact;

  const AttachmentContainer({
    super.key,
    required this.attachment,
    this.showFileName = true,
    this.compact = false,
  });

  @override
  State<AttachmentContainer> createState() => _AttachmentContainerState();
}

class _AttachmentContainerState extends State<AttachmentContainer> {
  final List<ImageSize> _sizes = [
    ImageSize.small,
    ImageSize.medium,
    ImageSize.large,
    ImageSize.original,
  ];
  int _current = 1;
  bool _isRetying = false;

  @override
  Widget build(BuildContext context) {
    if (isImage(widget.attachment.mimetype)) {
      final url =
          (_current < _sizes.length)
              ? widget.attachment.toImageUrl(imageSize: _sizes[_current])
              : widget.attachment.downloadUrl.withoutFormatJson;
      return CachedNetworkImage(
        imageUrl: url,
        cacheManager: DefaultCacheManager(),
        httpHeaders: Map<String, String>.from(
          DioFactory.getDio().options.headers,
        ),
        fadeOutDuration: const Duration(milliseconds: 300),
        imageBuilder:
            (ctx, imgProv) => _AttachmentContent(
              attachment: widget.attachment,
              imageProvider: imgProv,
              showFileName: widget.showFileName,
            ),
        progressIndicatorBuilder:
            (ctx, url, progress) => _AttachmentContent(
              attachment: widget.attachment,
              showFileName: widget.showFileName,
              allowDownload: false,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress.progress,
                      color:
                          _isRetying ? Theme.of(ctx).colorScheme.error : null,
                    ),
                    Text(
                      '${(progress.progress ?? 0) * 100 ~/ 1}%',
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                    if (_isRetying)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${context.tr('retry')} (${(_current + 1)}/${_sizes.length + 1})',
                            style: Theme.of(ctx).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        errorWidget: (ctx, url, error) {
          if (_current < _sizes.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _current++;
                _isRetying = true;
              });
            });
          }
          return _AttachmentContent(
            attachment: widget.attachment,
            showFileName: widget.showFileName,
            child: Center(
              child: Icon(
                Icons.hide_image_outlined,
                size: 72,
                color: Theme.of(ctx).colorScheme.outlineVariant,
              ),
            ),
          );
        },
      );
    } else if (isSVG(widget.attachment.mimetype)) {
      return FutureBuilder<String?>(
        future: getIt<DownloadManager>().getOrDownloadFile(
          widget.attachment.downloadUrl,
          widget.attachment.filename,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _AttachmentContent(
              attachment: widget.attachment,
              showFileName: widget.showFileName,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return _AttachmentContent(
              attachment: widget.attachment,
              showFileName: widget.showFileName,
              child: const Center(child: Icon(Icons.error_outline)),
            );
          }
          return _AttachmentContent(
            attachment: widget.attachment,
            showFileName: widget.showFileName,
            child: SvgPicture.file(File(snapshot.data!)),
          );
        },
      );
    }
    return _AttachmentContent(
      attachment: widget.attachment,
      showFileName: widget.showFileName,
      compact: widget.compact,
    );
  }
}

class _AttachmentContent extends StatefulWidget {
  final Attachment attachment;
  final Widget? child;
  final ImageProvider<Object>? imageProvider;
  final bool? showFileName;
  final bool? allowDownload;
  final bool? compact;

  const _AttachmentContent({
    required this.attachment,
    this.child,
    this.imageProvider,
    this.showFileName = true,
    this.allowDownload = true,
    this.compact = false,
  });

  @override
  State<_AttachmentContent> createState() => _AttachmentContentState();
}

class _AttachmentContentState extends State<_AttachmentContent> {
  double? _progress;
  late final String fileUrl;
  late final String mimetype;
  late final String filename;

  @override
  void initState() {
    super.initState();
    fileUrl = widget.attachment.downloadUrl;
    mimetype = widget.attachment.mimetype;
    filename = widget.attachment.filename;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final bg = theme.colorScheme.onInverseSurface;
    final shadow = theme.colorScheme.shadow.withAlpha(25);

    return Container(
      height: widget.compact == true ? size.height / 16 : 250,
      width: size.height / 4,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: shadow, blurRadius: 4)],
        image:
            widget.imageProvider != null
                ? DecorationImage(
                  image: widget.imageProvider!,
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                )
                : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.compact == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  widget.child ?? _buildTypeIcon(theme),
                  Text(
                    context.tr('openInExternalApp'),
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                  Icon(Icons.open_in_new, color: theme.colorScheme.secondary),
                ],
              ),
            ),
          if (widget.compact != true) widget.child ?? _buildTypeIcon(theme),
          if (_progress != null) ..._buildOverlay(theme, bg),
          if (widget.showFileName == true) _buildFilename(theme),
        ],
      ),
    ).tapScale(
      onTap:
          (_progress == null && widget.allowDownload == true)
              ? _download
              : null,
    );
  }

  List<Widget> _buildOverlay(ThemeData theme, Color bg) => [
    Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: bg.withAlpha(200),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: CircularProgressIndicator(value: _progress! / 100),
          ),
        )
        .animate(onComplete: (c) => c.repeat())
        .shimmer(
          duration: const Duration(seconds: 1),
          color: theme.colorScheme.primary.withAlpha(50),
        ),
    Text(
      '${_progress!.toInt()}%',
      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
    ),
  ];

  Widget _buildFilename(ThemeData theme) => Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        filename.lastAfterSlash,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );

  Widget _buildTypeIcon(ThemeData theme) {
    if (isImage(mimetype)) return const SizedBox.shrink();
    final patternIconMap = <Pattern, IconData>{
      'audio': FontAwesomeIcons.fileAudio,
      'video': FontAwesomeIcons.fileVideo,
      'pdf': FontAwesomeIcons.filePdf,
      'spreadsheetml': FontAwesomeIcons.fileExcel,
      'text': FontAwesomeIcons.fileLines,
      'json': FontAwesomeIcons.fileCode,
      'xml': FontAwesomeIcons.fileCode,
      'zip': FontAwesomeIcons.fileZipper,
      'x-7z-compressed': FontAwesomeIcons.fileZipper,
      'x-rar-compressed': FontAwesomeIcons.fileZipper,
      'x-tar': FontAwesomeIcons.fileZipper,
    };

    final entry = patternIconMap.entries.firstWhere(
      (e) => mimetype.contains(e.key),
      orElse: () => const MapEntry('', FontAwesomeIcons.file),
    );

    return FaIcon(entry.value, color: theme.colorScheme.secondary, size: 72.w);
  }

  Future<void> _download() async {
    setState(() => _progress = 0);
    final path = await getIt<DownloadManager>().getOrDownloadFile(
      fileUrl,
      filename,
      onProgress: (rec, total) {
        if (!mounted) return;
        setState(() => _progress = (rec / total * 100).truncateToDouble());
      },
    );
    if (!mounted) return;
    setState(() => _progress = null);
    await getIt<DownloadManager>().openFile(path);
  }
}
