import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/shared/models/in_app_message.dart';
import 'package:kobo/domain/usecases/notifications/get_in_app_messages.dart';

part 'notifications_state.dart';
part 'notifications_cubit.freezed.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetInAppMessages _getInAppMessages;
  NotificationsCubit(this._getInAppMessages) : super(const NotificationsState.loading()) {
    fetchInAppMessagesList();
  }

  List<AppMessage> _inAppMessagesList = [];
  void safeEmit(NotificationsState state) => !isClosed ? emit(state) : null;

  void fetchInAppMessagesList() async {
    safeEmit(const NotificationsState.loading());
    _inAppMessagesList = await _getInAppMessages();

    safeEmit(NotificationsState.success(_inAppMessagesList));
  }
}
