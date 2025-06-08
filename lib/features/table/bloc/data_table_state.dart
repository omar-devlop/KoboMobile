part of 'data_table_cubit.dart';

@freezed
class DataTableState with _$DataTableState {
  const factory DataTableState.initial() = _Initial;
  const factory DataTableState.loading({required String msg}) = Loading;
  const factory DataTableState.success(KoboFormRepository data) = Success;
  const factory DataTableState.error({required String error}) = Error;
}
