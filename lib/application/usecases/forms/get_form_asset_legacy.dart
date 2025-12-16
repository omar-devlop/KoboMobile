import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/services/kobo_service.dart';

/// Temporary adapter use case to keep legacy aggregate while we decompose KoboService.
class GetFormAssetLegacy {
  final KoboService _service;
  GetFormAssetLegacy(this._service);

  Future<KoboFormRepository?> call({required String uid, String? versionUid}) {
    return _service.fetchFormAsset(uid: uid, versionUid: versionUid);
  }
}


