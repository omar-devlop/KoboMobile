import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/features/form/model/submission_stats.dart';

part 'submission_stats_state.dart';
part 'submission_stats_cubit.freezed.dart';

class SubmissionStatsCubit extends Cubit<SubmissionStatsState> {
  SubmissionStatsCubit(String uid) : super(const SubmissionStatsState.empty()) {
    setUid(uid);
    fetchSubmissionStatsData();
  }
  late String uid;
  SubmissionStats submissionStats = SubmissionStats.empty();

  void safeEmit(SubmissionStatsState state) => !isClosed ? emit(state) : null;
  void setUid(String uid) => this.uid = uid;

  void fetchSubmissionStatsData({int? days}) async {
    safeEmit(const SubmissionStatsState.loading());

    submissionStats = await getIt<KoboService>().fetchFormDailySubmissionCounts(
      uid: uid,
      days: days,
    );

    safeEmit(SubmissionStatsState.success(submissionStats));
  }
}
