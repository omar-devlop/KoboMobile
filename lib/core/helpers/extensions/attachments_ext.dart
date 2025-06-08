import 'package:kobo/core/enums/image_sizes.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/models/attachment.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

extension AttachmentsExtensions on Attachment {
  /// Returns the image url `ImageSize` ---> small, medium, large, original
  String toImageUrl({ImageSize imageSize = ImageSize.original}) {
    String serverUrl = getIt<KoboService>().serverUrl;
    String imageUrl =
        '$serverUrl/media/${imageSize.toValue}?media_file=$filename';
    return imageUrl;
  }
}

extension StringImageExtensions on String {
  String toImageUrl(
    SubmissionData submissionData,
    String ownerUsername, {
    ImageSize imageSize = ImageSize.original,
  }) {
    KoboService koboService = getIt<KoboService>();
    String serverUrl = koboService.serverUrl;

    String imageUrl =
        '$serverUrl/media/${imageSize.toValue}?media_file=$ownerUsername/attachments/${submissionData.formhubUuid}/${submissionData.uuid}/$this';

    return imageUrl;
  }
}
