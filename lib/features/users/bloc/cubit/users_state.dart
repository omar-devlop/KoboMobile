part of 'users_cubit.dart';

@freezed
class UsersState with _$UsersState {
  const factory UsersState.loading({required String msg}) = Loading;
  const factory UsersState.savedUsers({
    required List<Account> data,
    String? loggingUserName,
  }) = SavedUsers;
  const factory UsersState.empty() = Empty;
  const factory UsersState.loginError({
    required List<Account> data,
    String? loggingUserName,
    required String error,
  }) = LoginError;
}
