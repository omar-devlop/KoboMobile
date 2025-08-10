import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/in_app_message.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/utils/routing/route_extensions.dart';
import 'package:kobo/features/about/bloc/git_hub_updater_cubit.dart';
import 'package:kobo/features/about/screen/about_screen.dart';
import 'package:kobo/features/attachment/bloc/attachments_cubit.dart';
import 'package:kobo/features/attachment/screen/attachments_screen.dart';

import 'package:kobo/features/auth/bloc/auth_cubit.dart';
import 'package:kobo/features/auth/screen/login_screen.dart';
import 'package:kobo/features/deep_search/bloc/deep_search_cubit.dart';
import 'package:kobo/features/deep_search/screen/deep_search_screen.dart';
import 'package:kobo/features/deployment_links/screen/deployment_links_screen.dart';
import 'package:kobo/features/empty/screen/empty_screen.dart';

import 'package:kobo/features/form/screen/form_screen.dart';
import 'package:kobo/features/form_users/screen/form_users_screen.dart';
import 'package:kobo/features/form_versions/screen/form_versions_screen.dart';

import 'package:kobo/features/home/bloc/kobo_forms_cubit.dart';
import 'package:kobo/features/home/screen/home_screen.dart';
import 'package:kobo/features/notifications/bloc/notifications_cubit.dart';
import 'package:kobo/features/notifications/screen/notification_details_screen.dart';
import 'package:kobo/features/notifications/screen/notification_screen.dart';
import 'package:kobo/features/reports/screen/report_screen.dart';

import 'package:kobo/features/users/bloc/cubit/users_cubit.dart';
import 'package:kobo/features/users/screen/users_screen.dart';

import 'package:kobo/features/content/bloc/form_content_cubit.dart';
import 'package:kobo/features/content/screen/content_screen.dart';

import 'package:kobo/features/data/bloc/data_cubit.dart';
import 'package:kobo/features/data/screen/data_screen.dart';

import 'package:kobo/features/submission/screen/submission_screen.dart';

import 'package:kobo/features/table/bloc/data_table_cubit.dart';
import 'package:kobo/features/table/screen/table_data_screen.dart';

import 'package:kobo/features/settings/screen/settings_screen.dart';
import 'package:kobo/features/settings/screen/languages_screen.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.aboutScreen:
        return BlocProvider(
          create: (context) => GitHubUpdaterCubit(),
          child: const AboutScreen(),
        ).scaleFadeRoute();
      case Routes.loginScreen:
        return BlocProvider(
          create: (_) => AuthCubit(),
          child: const LoginScreen(),
        ).scaleFadeRoute();

      case Routes.formScreen:
        final kForm = args as KoboForm;
        return FormScreen(kForm: kForm).scaleFadeRoute();

      case Routes.formVersionsScreen:
        final kForm = args as KoboForm;

        return BlocProvider(
          create: (_) => FormContentCubit(kForm.uid),
          child: FormVersionsScreen(kForm: kForm),
        ).scaleFadeRoute();

      case Routes.deploymentLinksScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (context) => FormContentCubit(kForm.uid),
          child: DeploymentLinksScreen(kForm: kForm),
        ).scaleFadeRoute();

      case Routes.homeScreen:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => KoboformsCubit()),
            BlocProvider(create: (_) => NotificationsCubit()),
          ],
          child: const HomeScreen(),
        ).scaleFadeRoute();

      case Routes.deepSearchScreen:
        return BlocProvider(
          create: (context) => DeepSearchCubit(),
          child: const DeepSearchScreen(),
        ).scaleFadeRoute();

      case Routes.notificationScreen:
        final cubit = args as NotificationsCubit;
        return BlocProvider.value(
          value: cubit,
          child: const NotificationScreen(),
        ).scaleFadeRoute();
      case Routes.notificationDetailsScreen:
        final payload = args as List;
        final inAppMessagesList = payload[0] as List<AppMessage>;
        final initialPage = payload[1] as int;
        return NotificationDetailsScreen(
          inAppMessagesList: inAppMessagesList,
          initialPage: initialPage,
        ).scaleFadeRoute();

      case Routes.usersScreen:
        return BlocProvider(
          create: (_) => UsersCubit(),
          child: const UsersScreen(),
        ).scaleFadeRoute();

      case Routes.contentScreen:
        final payload = args as List;
        final kForm = payload[0] as KoboForm;
        String? versionUid;
        if (payload.length > 1) {
          versionUid = payload[1];
        }
        return BlocProvider(
          create: (_) => FormContentCubit(kForm.uid, versionUid: versionUid),
          child: ContentScreen(kForm: kForm),
        ).scaleFadeRoute();

      case Routes.formUsersScreen:
        final kForm = args as KoboForm;
        return FormUsersScreen(kForm: kForm).scaleFadeRoute();

      case Routes.dataScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (_) => DataCubit(kForm.uid),
          child: DataScreen(kForm: kForm),
        ).scaleFadeRoute();
      case Routes.reportsScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (_) => DataCubit(kForm.uid, wholeData: true),
          child: ReportScreen(kForm: kForm),
        ).scaleFadeRoute();

      case Routes.submissionScreen:
        final payload = args as List;
        final repo = payload[0] as KoboFormRepository;
        final index = payload[1] as int;
        final cubit = payload[2] as DataCubit;

        return BlocProvider.value(
          value: cubit,
          child: SubmissionScreen(survey: repo, submissionIndex: index),
        ).scaleFadeRoute();

      case Routes.tableDataScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (_) => DataTableCubit(kForm.uid),
          child: TableDataScreen(kForm: kForm),
        ).scaleFadeRoute();

      case Routes.settingsScreen:
        return const SettingsScreen().scaleFadeRoute();

      case Routes.languagesScreen:
        return const LanguagesScreen().scaleFadeRoute();
      case Routes.emptyScreen:
        return const EmptyScreen().scaleFadeRoute();
      case Routes.attachmentsScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (context) => AttachmentsCubit(kForm.uid),
          child: AttachmentsScreen(kForm: kForm),
        ).scaleFadeRoute();

      default:
        return null;
    }
  }
}
