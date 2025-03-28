part of 'users_cubit.dart';

@freezed
class UsersState with _$UsersState {
  const factory UsersState.loading({required String msg}) = Loading;
  const factory UsersState.savedUsers({required List<String> data}) =
      SavedUsers;
  const factory UsersState.empty() = Empty;
  const factory UsersState.logging({
    required List<String> data,
    required String userName,
  }) = Logging;
}
