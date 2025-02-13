part of 'form_asset_cubit.dart';

@freezed
class FormAssetState with _$FormAssetState {
  const factory FormAssetState.initial() = _Initial;
  const factory FormAssetState.loading() = Loading;
  const factory FormAssetState.success(SurveyData data) = Success;
  const factory FormAssetState.error({required String error}) = Error;
}
