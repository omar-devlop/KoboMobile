import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/logic/cubits/form_content/form_content_cubit.dart';
import 'package:kobo/logic/cubits/form_data/form_data_cubit.dart';
import 'package:kobo/logic/cubits/kobo_forms/kobo_forms_cubit.dart';
import 'package:kobo/presentation/screens/empty/empty_screen.dart';
import 'package:kobo/presentation/screens/form/kobo_form_content_screen.dart';
import 'package:kobo/presentation/screens/form/kobo_form_data_screen.dart';
import 'package:kobo/presentation/screens/form/kobo_form_screen.dart';
import 'package:kobo/presentation/screens/home_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.emptyScreen: // to be used for testing
        return MaterialPageRoute(
          builder: (_) => const EmptyScreen(),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => KoboformsCubit(),
            child: const HomeScreen(),
          ),
        );

      case Routes.formScreen:
        KoboForm kForm = arguments as KoboForm;
        return MaterialPageRoute(
          builder: (_) => KoboFormScreen(kForm: kForm),
        );

      case Routes.formDataScreen:
        KoboForm kForm = arguments as KoboForm;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => FormDataCubit(kForm.uid),
            child: KoboFormDataScreen(kForm: kForm),
          ),
        );

      case Routes.formContentScreen:
        KoboForm kForm = arguments as KoboForm;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => FormContentCubit(kForm.uid),
            child: KoboFormContentScreen(kForm: kForm),
          ),
        );

      default:
        return null;
    }
  }
}
