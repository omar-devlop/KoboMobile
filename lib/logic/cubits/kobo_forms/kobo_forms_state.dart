part of 'kobo_forms_cubit.dart';

@freezed
class KoboformsState with _$KoboformsState {
  const factory KoboformsState.initial() = _Initial;
  const factory KoboformsState.loading() = Loading;
  const factory KoboformsState.success(List<KoboForm> data) = Success;
  const factory KoboformsState.error({required String error}) = Error;
}
