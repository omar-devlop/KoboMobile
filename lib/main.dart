import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/routing/app_router.dart';
import 'package:kobo/data/services/kobo_service.dart';
import 'package:kobo/kobo_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupGetIt();
  await getIt<KoboService>().fetchUserDetails();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: KoboApp(appRouter: AppRouter()),
    ),
  );
}
