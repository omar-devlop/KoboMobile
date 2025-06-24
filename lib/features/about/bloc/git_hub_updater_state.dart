part of 'git_hub_updater_cubit.dart';

@freezed
class GitHubUpdaterState with _$GitHubUpdaterState {
  const factory GitHubUpdaterState.initial() = _Initial;
  const factory GitHubUpdaterState.loading() = Loading;
  const factory GitHubUpdaterState.latest() = Latest;
  const factory GitHubUpdaterState.success(GitHubRelease gethubRelease) =
      Success;
  const factory GitHubUpdaterState.error({String? msg}) = Error;
}
