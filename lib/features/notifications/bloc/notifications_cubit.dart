import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/models/in_app_message.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

part 'notifications_state.dart';
part 'notifications_cubit.freezed.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState.loading()) {
    fetchInAppMessagesList();
  }

  List<AppMessage> _inAppMessagesList = [];
  void safeEmit(NotificationsState state) => !isClosed ? emit(state) : null;

  void fetchInAppMessagesList() async {
    safeEmit(const NotificationsState.loading());
    _inAppMessagesList = await getIt<KoboService>().fetchInAppMessages();

    safeEmit(NotificationsState.success(_inAppMessagesList));
  }
}
