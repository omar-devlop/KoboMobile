part of 'notifications_cubit.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = Loading;
  const factory NotificationsState.success(List<dynamic> inAppMessagesList) =
      Success;
}
