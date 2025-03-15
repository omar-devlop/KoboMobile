part of 'form_data_cubit.dart';

@freezed
class FormDataState with _$FormDataState {
  const factory FormDataState.initial() = _Initial;
  const factory FormDataState.loading({required List<SubmissionData> data}) =
      Loading;
  const factory FormDataState.success(List<SubmissionData> data) = Success;
  const factory FormDataState.error({required String error}) = Error;
}
