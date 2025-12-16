import 'package:kobo/core/enums/validation_type.dart';
import 'package:kobo/domain/repositories/submissions_repository.dart';

class UpdateValidationStatus {
  final SubmissionsRepository _repository;
  UpdateValidationStatus(this._repository);

  Future<bool> call({
    required String uid,
    required List<int> submissionIds,
    required ValidationType validationType,
  }) {
    return _repository.updateValidationStatus(
      uid: uid,
      submissionIds: submissionIds,
      validationType: validationType,
    );
  }
}


