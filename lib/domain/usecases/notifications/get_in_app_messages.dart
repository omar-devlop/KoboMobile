import 'package:kobo/core/shared/models/in_app_message.dart';
import 'package:kobo/domain/repositories/notifications_repository.dart';

class GetInAppMessages {
  final NotificationsRepository _repository;
  GetInAppMessages(this._repository);

  Future<List<AppMessage>> call() {
    return _repository.getInAppMessages();
  }
}


