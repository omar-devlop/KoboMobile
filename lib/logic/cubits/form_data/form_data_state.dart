part of 'form_data_cubit.dart';

@freezed
class FormDataState with _$FormDataState {
  const factory FormDataState.initial() = _Initial;
  const factory FormDataState.loading({required ResponseData data}) = Loading;
  const factory FormDataState.success(ResponseData data) = Success;
  const factory FormDataState.error({required String error}) = Error;
}
