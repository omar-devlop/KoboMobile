import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/data/modules/submission_data.dart';
import 'package:kobo/featuers/dataScreen/bloc/data_cubit.dart';
import 'package:kobo/featuers/dataScreen/screen/data_screen.dart';
import 'package:kobo/featuers/settingScreen/screen/settings_screen.dart';
import 'package:kobo/featuers/submissionScreen/screen/submission_screen.dart';
import 'package:kobo/logic/cubits/data_table/data_table_cubit.dart';
import 'package:kobo/logic/cubits/form_assets/form_asset_cubit.dart';
import 'package:kobo/featuers/contentScreen/bloc/form_content_cubit.dart';
import 'package:kobo/logic/cubits/form_data/form_data_cubit.dart';
import 'package:kobo/featuers/homeScreen/bloc/kobo_forms_cubit.dart';
import 'package:kobo/featuers/tableScreen/bloc/s_data_table_cubit.dart';
import 'package:kobo/presentation/screens/empty/empty_screen.dart';
import 'package:kobo/featuers/contentScreen/screen/content_screen.dart';
import 'package:kobo/featuers/tableScreen/screen/s_table_data_screen.dart';
import 'package:kobo/presentation/screens/form/form_screen.dart';
import 'package:kobo/presentation/screens/form/details/table_data_screen.dart';
import 'package:kobo/featuers/homeScreen/screen/home_screen.dart';

Widget getPage({required String pageName, dynamic arguments}) {
  switch (pageName) {
    case Routes.homeScreen: // HOME
      return BlocProvider(
        create: (context) => KoboformsCubit(),
        child: const HomeScreen(),
      );

    case Routes.formScreen: // FORM
      KoboForm kForm = arguments as KoboForm;
      return FormScreen(kForm: kForm);

    case Routes.tableDataScreen: // TABLE -- REMOVE
      KoboForm kForm = arguments as KoboForm;

      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FormDataCubit(kForm.uid)),
          BlocProvider(create: (context) => FormAssetCubit(kForm.uid)),
          BlocProvider(create: (context) => DataTableCubit(kForm.uid)),
        ],
        child: TableDataScreen(kForm: kForm),
      );

    case Routes.dataScreen: // DATA (Submissions)
      KoboForm kForm = arguments as KoboForm;

      return BlocProvider(
        create: (context) => DataCubit(kForm.uid),
        child: DataScreen(kForm: kForm),
      );
    case Routes.sTableDataScreen: // TABLE
      KoboForm kForm = arguments as KoboForm;

      return BlocProvider(
        create: (context) => SDataTableCubit(kForm.uid),
        child: STableDataScreen(kForm: kForm),
      );

    case Routes.contentScreen: // CONTENT (Questions)
      KoboForm kForm = arguments as KoboForm;

      return BlocProvider(
        create: (context) => FormContentCubit(kForm.uid),
        child: ContentScreen(kForm: kForm),
      );
    case Routes.submissionScreen: // SUBMISSION
      // KoboForm kForm = arguments as KoboForm;
      SubmissionData kForm = arguments as SubmissionData;
      return SubmissionScreen(submissionData: kForm);
    case Routes.settingsScreen: // SETTINGS
      return SettingsScreen();

    default:
      return const EmptyScreen();
  }
}
