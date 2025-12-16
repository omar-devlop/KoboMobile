import 'package:kobo/core/shared/models/in_app_message.dart';

/// Abstraction for in-app messages / notifications retrieval.
abstract class NotificationsRepository {
  Future<List<AppMessage>> getInAppMessages();
}


