part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading({required String msg}) = Loading;
  const factory AuthState.success() = Success;
  const factory AuthState.error({required String error}) = Error;
}
