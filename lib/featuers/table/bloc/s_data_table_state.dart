part of 's_data_table_cubit.dart';

@freezed
class SDataTableState with _$SDataTableState {
  const factory SDataTableState.initial() = _Initial;
  const factory SDataTableState.loading({required String msg}) = Loading;
  const factory SDataTableState.success(SurveyData  data) = Success;
  const factory SDataTableState.error({required String error}) = Error;
}
