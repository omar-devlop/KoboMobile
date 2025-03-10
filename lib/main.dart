import 'package:flutter/material.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/routing/app_router.dart';
import 'package:kobo/kobo_app.dart';


void main() {
  setupGetIt();
  runApp(KoboApp(appRouter: AppRouter()));
}
