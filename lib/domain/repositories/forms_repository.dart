import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/domain/entities/submission_stats.dart';
import 'package:kobo/core/shared/models/survey_item.dart';

/// Abstraction for forms-related operations in the domain layer.
/// Implementations must live in the infrastructure layer and must not leak
/// framework types (e.g., Dio, FormData) across this boundary.
abstract class FormsRepository {
  Future<List<KoboForm>> getForms();

  Future<KoboForm?> getFormAsset({
    required String uid,
    String? versionUid,
  });

  Future<List<SurveyItem>> getFormContent({
    required String uid,
  });

  Future<SubmissionStats> getDailySubmissionCounts({
    required String uid,
    int? days,
  });
}


