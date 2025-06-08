import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/services/kobo_service.dart';

part 'data_state.dart';
part 'data_cubit.freezed.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit(String uid, {bool wholeData = false})
    : super(const DataState.initial()) {
    setUid(uid);
    wholeData ? fetchWholeData() : fetchData();
  }
  late String uid;
  KoboFormRepository? survey;

  void safeEmit(DataState state) => !isClosed ? emit(state) : null;

  void setUid(String uid) => this.uid = uid;

  void fetchData({Map<String, dynamic>? additionalQuery}) async {
    safeEmit(DataState.loading(msg: tr("fetchingSurvey")));
    survey ??= await _fetchAsset();
    if (survey == null) {
      safeEmit(const DataState.error(error: "Survey data is not available"));
    } else {
      safeEmit(DataState.loading(msg: tr("fetchingData")));
      await survey!.fetchData(additionalQuery: additionalQuery);

      safeEmit(DataState.success(survey!));
    }
  }

  Future<bool> fetchMoreData() async {
    if (survey == null) return false;
    debugPrint("Fetch More Data [DataCubit] ...");

    safeEmit(DataState.success(survey!, isLoadingMore: true));
    await survey!.fetchMoreData();

    safeEmit(DataState.success(survey!));

    return true;
  }

  Future<bool> fetchWholeData({Map<String, dynamic>? additionalQuery}) async {
    safeEmit(DataState.loading(msg: tr("fetchingSurvey")));
    survey ??= await _fetchAsset();
    if (survey == null) {
      safeEmit(const DataState.error(error: "Survey data is not available"));
    } else {
      safeEmit(DataState.loading(msg: tr("fetchingData")));

      await survey!.fetchWholeData(additionalQuery: additionalQuery);

      safeEmit(DataState.success(survey!));
    }
    return false;
  }

  Future<void> reFetchSubmissions(List<int> ids) async {
    safeEmit(DataState.success(survey!, isUpdating: true));
    bool isUpdated = await survey!.reFetchSubmissions(ids);
    if (isUpdated) {
      safeEmit(DataState.success(survey!));
    }
  }

  Future<KoboFormRepository?> _fetchAsset() async =>
      await getIt<KoboService>().fetchFormAsset(uid: uid);
}
