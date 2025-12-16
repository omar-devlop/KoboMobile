import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/domain/repositories/submissions_repository.dart';

class GetFormDataPage {
  final SubmissionsRepository _repository;
  GetFormDataPage(this._repository);

  Future<ResponseData> call({
    required String uid,
    int start = 0,
    Map<String, dynamic>? additionalQuery,
    int? limit,
  }) {
    return _repository.getFormData(
      uid: uid,
      start: start,
      additionalQuery: additionalQuery,
      limit: limit,
    );
  }
}


