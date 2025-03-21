import 'package:flutter/material.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/routing/app_router.dart';
import 'package:kobo/data/services/kobo_service.dart';
import 'package:kobo/kobo_app.dart';

Future<void> main() async {
  setupGetIt();
  await getIt<KoboService>().fetchUserDetails();
  runApp(KoboApp(appRouter: AppRouter()));
}
