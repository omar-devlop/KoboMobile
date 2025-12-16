import 'package:kobo/core/enums/validation_type.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kobo/core/helpers/extensions/validation_type_ext.dart';
import 'package:kobo/infrastructure/datasources/kobo_remote_data_source.dart';
import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/domain/repositories/submissions_repository.dart';

class SubmissionsRepositoryImpl implements SubmissionsRepository {
  final KoboRemoteDataSource _remote;
  SubmissionsRepositoryImpl(this._remote);

  @override
  Future<ResponseData> getFormData({
    required String uid,
    int start = 0,
    Map<String, dynamic>? additionalQuery,
    int? limit,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'format': 'json',
      'start': start,
      'sort': '{"_id":-1}',
      'limit': limit,
    };
    if (additionalQuery != null) {
      queryParameters['query'] = jsonEncode(additionalQuery);
    }
    // Remove nulls (e.g., limit=null means no limit)
    queryParameters.removeWhere((key, value) => value == null);

    final response = await _remote.getFormData(uid, queryParameters);
    if (response.statusCode == 200) {
      return ResponseData(
        count: response.data["count"],
        next: response.data["next"],
        previous: response.data["previous"],
        results:
            (response.data["results"] as List<dynamic>)
                .map<SubmissionData>((json) => SubmissionData.fromJson(json))
                .toList(),
      );
    }
    return ResponseData.empty();
  }

  @override
  Future<SubmissionData?> getSubmission({
    required String uid,
    required int id,
  }) async {
    final response = await _remote.getFormSubmission(uid, id);
    if (response.statusCode == 200) {
      return SubmissionData.fromJson(response.data);
    }
    return null;
  }

  @override
  Future<bool> updateValidationStatus({
    required String uid,
    required List<int> submissionIds,
    required ValidationType validationType,
  }) async {
    try {
      final payload =
          '{"submission_ids":[${submissionIds.map((id) => '"$id"').join(',')}],"validation_status.uid":"${validationType.toApiValue}"}';
      final data = FormData.fromMap({'payload': payload});
      final response = await _remote.patchValidationStatus(uid, data);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
