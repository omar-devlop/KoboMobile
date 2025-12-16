import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/domain/usecases/forms/get_daily_submission_counts.dart';
import 'package:kobo/domain/entities/submission_stats.dart';

part 'submission_stats_state.dart';
part 'submission_stats_cubit.freezed.dart';

class SubmissionStatsCubit extends Cubit<SubmissionStatsState> {
  final GetDailySubmissionCounts _getDailySubmissionCounts;
  SubmissionStatsCubit(String uid, this._getDailySubmissionCounts) : super(const SubmissionStatsState.empty()) {
    setUid(uid);
    fetchSubmissionStatsData();
  }
  late String uid;
  SubmissionStats submissionStats = SubmissionStats.empty();

  void safeEmit(SubmissionStatsState state) => !isClosed ? emit(state) : null;
  void setUid(String uid) => this.uid = uid;

  void fetchSubmissionStatsData({int? days}) async {
    safeEmit(const SubmissionStatsState.loading());

    submissionStats = await _getDailySubmissionCounts(uid: uid, days: days);

    safeEmit(SubmissionStatsState.success(submissionStats));
  }
}
