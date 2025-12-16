import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

/// Thin adapter around FirebaseMessaging to expose a simple stream
/// that presentation/application can subscribe to without importing
/// Firebase directly.
class FirebaseNotificationsAdapter {
  final StreamController<RemoteMessage> _controller =
      StreamController.broadcast();

  FirebaseNotificationsAdapter() {
    _listenForegroundMessages();
  }

  Stream<RemoteMessage> get onMessage => _controller.stream;

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _controller.add(message);
    });
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
