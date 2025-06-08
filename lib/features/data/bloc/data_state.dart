part of 'data_cubit.dart';

@freezed
class DataState with _$DataState {
  const factory DataState.initial() = _Initial;
  const factory DataState.loading({required String msg}) = Loading;
  const factory DataState.success(
    KoboFormRepository data, {
    bool? isLoadingMore,
    bool? isUpdating,
  }) = Success;
  const factory DataState.error({required String error}) = Error;
}
