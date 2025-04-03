import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/core/services/kobo_service.dart';

part 'form_asset_state.dart';
part 'form_asset_cubit.freezed.dart';

class FormAssetCubit extends Cubit<FormAssetState> {
  FormAssetCubit(String uid) : super(FormAssetState.initial()) {
    fetchAsset(uid);
  }
  void safeEmit(FormAssetState state) => !isClosed ? emit(state) : null;

  SurveyData? data;

  void fetchAsset(String uid) async {
    safeEmit(FormAssetState.loading());
    data = await getIt<KoboService>().fetchFormAsset(uid: uid);
    safeEmit(
        FormAssetState.success(data ??= SurveyData(survey: [], choices: [])));
  }
}
