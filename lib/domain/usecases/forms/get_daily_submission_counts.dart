import 'package:kobo/domain/entities/submission_stats.dart';
import 'package:kobo/domain/repositories/forms_repository.dart';

class GetDailySubmissionCounts {
  final FormsRepository _repository;
  GetDailySubmissionCounts(this._repository);

  Future<SubmissionStats> call({required String uid, int? days}) {
    return _repository.getDailySubmissionCounts(uid: uid, days: days);
  }
}


