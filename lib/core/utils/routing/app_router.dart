import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/featuers/auth/bloc/auth_cubit.dart';
import 'package:kobo/featuers/auth/screen/login_screen.dart';
import 'package:kobo/featuers/data/bloc/data_cubit.dart';
import 'package:kobo/featuers/data/screen/data_screen.dart';
import 'package:kobo/featuers/settings/screen/languages_screen.dart';
import 'package:kobo/featuers/settings/screen/settings_screen.dart';
import 'package:kobo/featuers/table/bloc/data_table_cubit.dart';
import 'package:kobo/featuers/users/bloc/cubit/users_cubit.dart';
import 'package:kobo/featuers/users/screen/users_screen.dart';
import 'package:kobo/featuers/home/bloc/kobo_forms_cubit.dart';
import 'package:kobo/presentation/screens/empty/empty_screen.dart';
import 'package:kobo/featuers/table/screen/table_data_screen.dart';
import 'package:kobo/presentation/screens/form/form_screen.dart';
import 'package:kobo/featuers/home/screen/home_screen.dart';

class AppRouter {
  PageRouteBuilder<dynamic> slideTransitionPage(Widget page, {Offset? offset}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = offset ?? Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.emptyScreen: // to be used for testing
        return MaterialPageRoute(builder: (_) => const EmptyScreen());
      case Routes.usersScreen: // LOGIN
        return slideTransitionPage(
          BlocProvider(
            create: (context) => UsersCubit(),
            child: const UsersScreen(),
          ),
        );

      case Routes.loginScreen: // LOGIN
        return slideTransitionPage(
          BlocProvider(
            create: (context) => AuthCubit(),
            child: const LoginScreen(),
          ),
          offset: Offset(0.0, -1.0),
        );
      case Routes.homeScreen: // HOME
        return slideTransitionPage(
          BlocProvider(
            create: (context) => KoboformsCubit(),
            child: const HomeScreen(),
          ),
        );

      case Routes.formScreen: // FORM
        KoboForm kForm = arguments as KoboForm;
        return MaterialPageRoute(builder: (_) => FormScreen(kForm: kForm));

      case Routes.dataScreen: // DATA (Submissions)
        KoboForm kForm = arguments as KoboForm;
        return slideTransitionPage(
          BlocProvider(
            create: (context) => DataCubit(kForm.uid),
            child: DataScreen(kForm: kForm),
          ),
        );
      case Routes.tableDataScreen: // TABLE
        KoboForm kForm = arguments as KoboForm;
        return slideTransitionPage(
          BlocProvider(
            create: (context) => DataTableCubit(kForm.uid),
            child: TableDataScreen(kForm: kForm),
          ),
        );

      case Routes.settingsScreen: // SETTINGS
        return slideTransitionPage(SettingsScreen());
      case Routes.languagesScreen: // LANGUAGES
        return slideTransitionPage(LanguagesScreen());

      default:
        return null;
    }
  }
}
