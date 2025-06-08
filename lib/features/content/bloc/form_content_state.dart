part of 'form_content_cubit.dart';

@freezed
class FormContentState with _$FormContentState {
  const factory FormContentState.loading({required String msg}) = Loading;
  const factory FormContentState.success(KoboFormRepository data) = Success;
  const factory FormContentState.error({required String error}) = Error;
}
