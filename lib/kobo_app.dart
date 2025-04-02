import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/theme/app_theme.dart';
import 'package:kobo/core/utils/routing/app_router.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kobo/featuers/settings/bloc/accent_color_cubit.dart';
import 'package:kobo/featuers/settings/bloc/theme_cubit.dart';

class KoboApp extends StatelessWidget {
  final AppRouter appRouter;
  const KoboApp({super.key, required this.appRouter});

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
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    themeMode: themeMode,
                    theme: lightTheme(context, lightDynamic?.harmonized()),
                    darkTheme: darkTheme(context, darkDynamic?.harmonized()),
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    initialRoute: Routes.usersScreen,
                    onGenerateRoute: appRouter.generateRoute,
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
