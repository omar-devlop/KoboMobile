import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/response_data.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/core/services/kobo_service.dart';

part 'data_state.dart';
part 'data_cubit.freezed.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit(String uid) : super(DataState.initial()) {
    setUid(uid);
    fetchTableData();
  }
  late String uid;
  SurveyData surveyData = SurveyData();

  void safeEmit(DataState state) => !isClosed ? emit(state) : null;

  void setUid(String uid) => this.uid = uid;

  void fetchTableData() async {
    safeEmit(DataState.loading(msg: "Fetching survey..."));

    surveyData = await _fetchAsset();

    safeEmit(DataState.loading(msg: "Fetching data..."));

    surveyData.data = await _fetchData();

    safeEmit(DataState.success(surveyData));
  }

  Future<bool> fetchMoreData() async {
    ResponseData newData = await _fetchData(
      start: surveyData.data!.results.length,
    );
    surveyData.data!.results.addAll(newData.results);
    safeEmit(DataState.success(surveyData));
    return true;
  }

  Future<SurveyData> _fetchAsset() async =>
      await getIt<KoboService>().fetchFormAsset(uid: uid);

  Future<ResponseData> _fetchData({int start = 0}) async =>
      await getIt<KoboService>().fetchFormData(uid: uid, start: start);
}
