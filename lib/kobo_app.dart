import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobo/core/theme/app_theme.dart';
import 'package:kobo/core/utils/routing/app_router.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kobo/features/settings/bloc/accent_color_cubit.dart';
import 'package:kobo/features/settings/bloc/theme_cubit.dart';
import 'package:kobo/main.dart';

class KoboApp extends StatefulWidget {
  final AppRouter appRouter;
  const KoboApp({super.key, required this.appRouter});

  @override
  State<KoboApp> createState() => _KoboAppState();
}

class _KoboAppState extends State<KoboApp> {
  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Handling foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFlutterNotification(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => AccentColorCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<AccentColorCubit, Color>(
            builder: (context, color) {
              return DynamicColorBuilder(
                builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
                  return ScreenUtilInit(
                    designSize: const Size(1080, 2400),
                    minTextAdapt: true,
                    splitScreenMode: true,
                    builder:
                        (context, child) => MaterialApp(
                          debugShowCheckedModeBanner: false,
                          themeMode: themeMode,
                          theme: lightTheme(
                            context,
                            lightDynamic?.harmonized(),
                          ),
                          darkTheme: darkTheme(
                            context,
                            darkDynamic?.harmonized(),
                          ),
                          localizationsDelegates: context.localizationDelegates,
                          supportedLocales: context.supportedLocales,
                          locale: context.locale,
                          initialRoute: Routes.usersScreen,
                          onGenerateRoute: widget.appRouter.generateRoute,
                        ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
