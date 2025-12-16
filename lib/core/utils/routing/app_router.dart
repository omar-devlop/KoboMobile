import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/cubits/kobo_form/k_form_cubit.dart';

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
import 'package:kobo/features/export/screen/export_screen.dart';

import 'package:kobo/features/form/screen/form_screen.dart';
import 'package:kobo/features/form_users/screen/form_users_screen.dart';
import 'package:kobo/features/form_versions/screen/form_versions_screen.dart';

import 'package:kobo/features/home/bloc/kobo_forms_cubit.dart';
import 'package:kobo/features/home/screen/home_screen.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/domain/usecases/forms/get_forms.dart';
import 'package:kobo/features/notifications/bloc/notifications_cubit.dart';
import 'package:kobo/features/notifications/screen/notification_details_screen.dart';
import 'package:kobo/features/notifications/screen/notification_screen.dart';
import 'package:kobo/features/reports/screen/report_screen.dart';

import 'package:kobo/features/users/bloc/cubit/users_cubit.dart';
import 'package:kobo/features/users/screen/users_screen.dart';
import 'package:kobo/features/users/bloc/current_user_cubit.dart';

import 'package:kobo/features/content/bloc/form_content_cubit.dart';
import 'package:kobo/features/content/screen/content_screen.dart';

import 'package:kobo/features/data/bloc/data_cubit.dart';
import 'package:kobo/features/data/screen/data_screen.dart';

import 'package:kobo/features/submission/screen/submission_screen.dart';

import 'package:kobo/features/table/bloc/data_table_cubit.dart';
import 'package:kobo/features/table/screen/table_data_screen.dart';

import 'package:kobo/features/settings/screen/settings_screen.dart';
import 'package:kobo/features/settings/screen/languages_screen.dart';
import 'package:kobo/domain/usecases/accounts/get_user.dart';
import 'package:kobo/domain/usecases/notifications/get_in_app_messages.dart';
import 'package:kobo/application/usecases/forms/get_form_asset_legacy.dart';
import 'package:kobo/domain/usecases/submissions/get_form_data_page.dart';

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
          create: (_) => FormContentCubit(kForm.uid, getIt<GetFormAssetLegacy>()),
          child: FormVersionsScreen(kForm: kForm),
        ).scaleFadeRoute();

      case Routes.deploymentLinksScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (context) => FormContentCubit(kForm.uid, getIt<GetFormAssetLegacy>()),
          child: DeploymentLinksScreen(kForm: kForm),
        ).scaleFadeRoute();

      case Routes.homeScreen:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => KoboformsCubit(getIt<GetForms>())),
            BlocProvider(create: (_) => NotificationsCubit(getIt<GetInAppMessages>())),
            BlocProvider(create: (_) => CurrentUserCubit(getIt<GetUser>())..load()),
          ],
          child: const HomeScreen(),
        ).scaleFadeRoute();

      case Routes.deepSearchScreen:
        return BlocProvider(
          create: (context) => DeepSearchCubit(
            getIt<GetForms>(),
            getIt<GetFormDataPage>(),
          ),
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
          create: (_) => FormContentCubit(kForm.uid, getIt<GetFormAssetLegacy>(), versionUid: versionUid),
          child: ContentScreen(kForm: kForm),
        ).scaleFadeRoute();

      case Routes.formUsersScreen:
        final kForm = args as KoboForm;
        return FormUsersScreen(kForm: kForm).scaleFadeRoute();

      case Routes.dataScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (_) => DataCubit(kForm.uid, getFormAsset: getIt<GetFormAssetLegacy>()),
          child: DataScreen(kForm: kForm),
        ).scaleFadeRoute();
      case Routes.reportsScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (_) => DataCubit(kForm.uid, wholeData: true, getFormAsset: getIt<GetFormAssetLegacy>()),
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
          create: (_) => DataTableCubit(kForm.uid, getIt<GetFormAssetLegacy>()),
          child: TableDataScreen(kForm: kForm),
        ).scaleFadeRoute();
        
      case Routes.exportScreen:
        final kForm = args as KoboForm;
        return BlocProvider(
          create: (_) => KFormCubit(kForm.uid, getIt<GetFormAssetLegacy>()),
          child: ExportScreen(kForm: kForm),
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
          create: (context) => AttachmentsCubit(kForm.uid, getIt<GetFormAssetLegacy>()),
          child: AttachmentsScreen(kForm: kForm),
        ).scaleFadeRoute();

      default:
        return null;
    }
  }
}
