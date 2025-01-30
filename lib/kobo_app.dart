import 'package:flutter/material.dart';
import 'package:kobo/core/utils/routing/app_router.dart';
import 'package:kobo/core/utils/routing/routes.dart';

class KoboApp extends StatelessWidget {
  final AppRouter appRouter;
  const KoboApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          Routes.homeScreen, // true ? Routes.homeScreen : Routes.emptyScreen,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
