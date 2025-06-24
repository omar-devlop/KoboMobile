import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/features/about/model/github_release.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'git_hub_updater_state.dart';
part 'git_hub_updater_cubit.freezed.dart';

class GitHubUpdaterCubit extends Cubit<GitHubUpdaterState> {
  GitHubUpdaterCubit() : super(const GitHubUpdaterState.initial()) {
    checkForUpdate();
  }

  void safeEmit(GitHubUpdaterState state) => !isClosed ? emit(state) : null;

  GitHubRelease? latestRelease;
  String? errorMsg;

  Future<void> checkForUpdate() async {
    errorMsg = null;
    safeEmit(const GitHubUpdaterState.loading());
    final currentVersion = getIt<PackageInfo>().version;
    await _fetchLatestReleaseVersion();
    if (latestRelease == null) {
      safeEmit(GitHubUpdaterState.error(msg: errorMsg));

      return;
    }
    final latestVersion = latestRelease!.name.replaceFirst(
      RegExp(r'^[vV]'),
      '',
    );
    if (currentVersion != latestVersion) {
      safeEmit(GitHubUpdaterState.success(latestRelease!));
      return;
    }

    safeEmit(const GitHubUpdaterState.latest());
  }

  Future<void> _fetchLatestReleaseVersion() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.github.com/repos/omar-devlop/KoboMobile/releases/latest',
      );

      if (response.statusCode == 403) {
        errorMsg = "rateLimit";
        return;
      }
      if (response.statusCode == 200) {
        final data = response.data;
        latestRelease = GitHubRelease.fromJson(data);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
