import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/core/enums/validation_type.dart';

/// Abstraction for submissions-related operations.
abstract class SubmissionsRepository {
  Future<ResponseData> getFormData({
    required String uid,
    int start = 0,
    Map<String, dynamic>? additionalQuery,
    int? limit,
  });

  Future<SubmissionData?> getSubmission({
    required String uid,
    required int id,
  });

  Future<bool> updateValidationStatus({
    required String uid,
    required List<int> submissionIds,
    required ValidationType validationType,
  });
}


