import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/logic/cubits/data_table/data_table_cubit.dart';
import 'package:kobo/logic/cubits/form_assets/form_asset_cubit.dart';
import 'package:kobo/featuers/contentScreen/bloc/form_content_cubit.dart';
import 'package:kobo/logic/cubits/form_data/form_data_cubit.dart';
import 'package:kobo/featuers/homeScreen/bloc/kobo_forms_cubit.dart';
import 'package:kobo/featuers/tableScreen/bloc/s_data_table_cubit.dart';
import 'package:kobo/presentation/screens/empty/empty_screen.dart';
import 'package:kobo/featuers/contentScreen/screen/content_screen.dart';
import 'package:kobo/presentation/screens/form/details/data_screen.dart';
import 'package:kobo/featuers/tableScreen/screen/s_table_data_screen.dart';
import 'package:kobo/presentation/screens/form/form_screen.dart';
import 'package:kobo/presentation/screens/form/details/table_data_screen.dart';
import 'package:kobo/featuers/homeScreen/screen/home_screen.dart';

class AppRouter {
  PageRouteBuilder<dynamic> slideTransitionPage(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
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

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => KoboformsCubit(),
                child: const HomeScreen(),
              ),
        );

      case Routes.formScreen:
        KoboForm kForm = arguments as KoboForm;
        return MaterialPageRoute(builder: (_) => FormScreen(kForm: kForm));

      case Routes.dataScreen:
        KoboForm kForm = arguments as KoboForm;

        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => FormDataCubit(kForm.uid),
                child: DataScreen(kForm: kForm),
              ),
        );

      case Routes.tableDataScreen:
        KoboForm kForm = arguments as KoboForm;

        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => FormDataCubit(kForm.uid)),
                  BlocProvider(create: (context) => FormAssetCubit(kForm.uid)),
                  BlocProvider(create: (context) => DataTableCubit(kForm.uid)),
                ],
                child: TableDataScreen(kForm: kForm),
              ),
        );

      case Routes.sTableDataScreen:
        KoboForm kForm = arguments as KoboForm;
        return slideTransitionPage(
          BlocProvider(
            create: (context) => SDataTableCubit(kForm.uid),
            child: STableDataScreen(kForm: kForm),
          ),
        );

      case Routes.contentScreen:
        KoboForm kForm = arguments as KoboForm;
        return slideTransitionPage(
          BlocProvider(
            create: (context) => FormContentCubit(kForm.uid),
            child: ContentScreen(kForm: kForm),
          ),
        );

      default:
        return null;
    }
  }
}
