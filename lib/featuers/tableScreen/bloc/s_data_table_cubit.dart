import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/submission_data.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/services/kobo_service.dart';

part 's_data_table_state.dart';
part 's_data_table_cubit.freezed.dart';

class SDataTableCubit extends Cubit<SDataTableState> {
  SDataTableCubit(String uid) : super(SDataTableState.initial()) {
    setUid(uid);
    fetchTableData();
  }
  late String uid;
  SurveyData surveyData = SurveyData();

  void safeEmit(SDataTableState state) => !isClosed ? emit(state) : null;

  void setUid(String uid) => this.uid = uid;

  void fetchTableData() async {
    safeEmit(SDataTableState.loading(msg: "Fetching survey..."));

    surveyData = await _fetchAsset();

    safeEmit(SDataTableState.loading(msg: "Fetching data..."));

    surveyData.data = await _fetchData();

    safeEmit(SDataTableState.success(surveyData));
  }

  Future<SurveyData> _fetchAsset() async =>
      await getIt<KoboService>().fetchFormAsset(uid: uid);

  Future<List<SubmissionData>> _fetchData() async =>
      await getIt<KoboService>().fetchFormData(uid: uid);
}
