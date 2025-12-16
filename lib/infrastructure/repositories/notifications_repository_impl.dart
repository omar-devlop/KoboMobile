import 'package:kobo/infrastructure/datasources/kobo_remote_data_source.dart';
import 'package:kobo/core/shared/models/in_app_message.dart';
import 'package:kobo/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final KoboRemoteDataSource _remote;
  NotificationsRepositoryImpl(this._remote);

  @override
  Future<List<AppMessage>> getInAppMessages() async {
    final response = await _remote.getInAppMessages();
    if (response.statusCode == 200) {
      final list = response.data["results"] as List<dynamic>? ?? [];
      return list.map((e) => AppMessage.fromJson(e)).toList();
    }
    return [];
  }
}


