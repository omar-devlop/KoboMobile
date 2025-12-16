import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/domain/repositories/submissions_repository.dart';

class GetSubmission {
  final SubmissionsRepository _repository;
  GetSubmission(this._repository);

  Future<SubmissionData?> call({required String uid, required int id}) {
    return _repository.getSubmission(uid: uid, id: id);
  }
}


