part of 'form_content_cubit.dart';

@freezed
class FormContentState with _$FormContentState {
  const factory FormContentState.initial() = _Initial;
  const factory FormContentState.loading({required String msg}) = Loading;
  const factory FormContentState.success(List<SurveyItem> data) = Success;
  const factory FormContentState.error({required String error}) = Error;
}
