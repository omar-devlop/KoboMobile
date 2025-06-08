import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

part 'data_table_state.dart';
part 'data_table_cubit.freezed.dart';

class DataTableCubit extends Cubit<DataTableState> {
  DataTableCubit(String uid) : super(const DataTableState.initial()) {
    setUid(uid);
    fetchData();
  }
  late String uid;
  KoboFormRepository? survey;

  void safeEmit(DataTableState state) => !isClosed ? emit(state) : null;

  void setUid(String uid) => this.uid = uid;

  void fetchData() async {
    safeEmit(DataTableState.loading(msg: tr("fetchingSurvey")));

    survey = await _fetchAsset();

    if (survey != null) {
      safeEmit(DataTableState.success(survey!));
    } else {
      safeEmit(
        const DataTableState.error(error: "Survey data is not available"),
      );
    }
  }

  Future<dynamic> _fetchAsset() async =>
      await getIt<KoboService>().fetchFormAsset(uid: uid);
}
