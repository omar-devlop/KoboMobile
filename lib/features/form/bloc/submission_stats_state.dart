part of 'submission_stats_cubit.dart';

@freezed
class SubmissionStatsState with _$SubmissionStatsState {
  const factory SubmissionStatsState.empty() = Empty;
  const factory SubmissionStatsState.loading() = Loading;
  const factory SubmissionStatsState.success(SubmissionStats submissionStats) =
      Success;
}
