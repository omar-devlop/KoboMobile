part of 'k_form_cubit.dart';

@freezed
class KFormState with _$KFormState {
  const factory KFormState.initial() = _Initial;
  const factory KFormState.loading({required String msg}) = Loading;
  const factory KFormState.success(
    KoboFormRepository kForm, {
    @Default(false) bool isLoadingMore,
  }) = Success;
  const factory KFormState.error({required String error}) = Error;
}
