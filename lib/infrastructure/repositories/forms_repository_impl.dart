import 'package:kobo/infrastructure/datasources/kobo_remote_data_source.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/domain/repositories/forms_repository.dart';
import 'package:kobo/domain/entities/submission_stats.dart';

class FormsRepositoryImpl implements FormsRepository {
  final KoboRemoteDataSource _remote;
  FormsRepositoryImpl(this._remote);

  @override
  Future<List<KoboForm>> getForms() async {
    final response = await _remote.getForms();
    if (response.statusCode == 200) {
      final results = response.data["results"] as List<dynamic>? ?? [];
      return results.map<KoboForm>((json) => KoboForm.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<KoboForm?> getFormAsset({required String uid, String? versionUid}) async {
    // Not yet migrated: the legacy service returns a KoboFormRepository aggregate.
    // Defer proper mapping in a later phase when we extract the aggregator.
    throw UnimplementedError('getFormAsset will be implemented during migration');
  }

  @override
  Future<List<SurveyItem>> getFormContent({required String uid}) async {
    final response = await _remote.getFormContent(uid);
    if (response.statusCode == 200) {
      final List<dynamic> survey = response.data["data"]?["survey"] ?? [];
      return survey.map<SurveyItem>((json) => SurveyItem.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<SubmissionStats> getDailySubmissionCounts({required String uid, int? days}) async {
    final response = await _remote.getFormDailySubmissionCounts(uid, days: days);
    if (response.statusCode == 200) {
      return SubmissionStats.fromJson(response.data);
    }
    return SubmissionStats.empty();
  }
}


