import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kobo/core/services/cloudflare_service.dart';
import 'package:kobo/core/services/pdf_service.dart';
import 'package:kobo/core/utils/networking/dio_factory.dart';
import 'package:kobo/features/users/model/account_repository.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/services/download_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:kobo/domain/repositories/forms_repository.dart';
import 'package:kobo/domain/repositories/submissions_repository.dart';
import 'package:kobo/domain/repositories/notifications_repository.dart';
import 'package:kobo/domain/repositories/accounts_repository.dart'
    as domain_accounts;
import 'package:kobo/infrastructure/repositories/forms_repository_impl.dart';
import 'package:kobo/infrastructure/repositories/submissions_repository_impl.dart';
import 'package:kobo/infrastructure/repositories/notifications_repository_impl.dart';
import 'package:kobo/infrastructure/repositories/accounts_repository_impl.dart';
import 'package:kobo/domain/usecases/forms/get_forms.dart';
import 'package:kobo/domain/usecases/forms/get_daily_submission_counts.dart';
import 'package:kobo/domain/usecases/accounts/get_user.dart';
import 'package:kobo/domain/usecases/notifications/get_in_app_messages.dart';
import 'package:kobo/domain/usecases/submissions/get_form_data_page.dart';
import 'package:kobo/domain/usecases/submissions/get_submission.dart';
import 'package:kobo/domain/usecases/submissions/update_validation_status.dart';
import 'package:kobo/application/usecases/forms/get_form_asset_legacy.dart';
import 'package:kobo/infrastructure/datasources/kobo_remote_data_source.dart';
import 'package:kobo/infrastructure/notifications/firebase_notifications_adapter.dart';

final getIt = GetIt.instance;

/// Sets up the application's dependencies via GetIt.
Future<void> setupGetIt() async {
  // Create a shared Dio instance
  Dio dio = DioFactory.getDio();

  // Register services and repositories
  getIt.registerLazySingleton<KoboService>(() => KoboService(dio));
  getIt.registerLazySingleton<KoboRemoteDataSource>(
    () => KoboRemoteDataSource(dio),
  );
  getIt.registerLazySingleton<FirebaseNotificationsAdapter>(
    () => FirebaseNotificationsAdapter(),
  );
  getIt.registerLazySingleton<AccountRepository>(() => AccountRepository());
  getIt.registerSingletonAsync<PdfService>(() async {
    final service = PdfService();
    await service.initService();
    return service;
  });

  getIt.registerSingletonAsync<PackageInfo>(
    () async => await PackageInfo.fromPlatform(),
  );

  // Register the DownloadManager to handle file downloads & openings
  getIt.registerLazySingleton<DownloadManager>(() => DownloadManager(dio));

  getIt.registerLazySingleton<CloudflareService>(() => CloudflareService());

  // Domain repositories bound to infra implementations (temporary delegating to KoboService)
  getIt.registerLazySingleton<FormsRepository>(
    () => FormsRepositoryImpl(getIt<KoboRemoteDataSource>()),
  );
  getIt.registerLazySingleton<SubmissionsRepository>(
    () => SubmissionsRepositoryImpl(getIt<KoboRemoteDataSource>()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt<KoboRemoteDataSource>()),
  );
  getIt.registerLazySingleton<domain_accounts.AccountsRepository>(
    () => AccountsRepositoryImpl(getIt<KoboRemoteDataSource>()),
  );

  // Use cases
  getIt.registerFactory<GetForms>(() => GetForms(getIt<FormsRepository>()));
  getIt.registerFactory<GetDailySubmissionCounts>(
    () => GetDailySubmissionCounts(getIt<FormsRepository>()),
  );
  getIt.registerFactory<GetUser>(
    () => GetUser(getIt<domain_accounts.AccountsRepository>()),
  );
  getIt.registerFactory<GetInAppMessages>(
    () => GetInAppMessages(getIt<NotificationsRepository>()),
  );
  getIt.registerFactory<GetFormDataPage>(
    () => GetFormDataPage(getIt<SubmissionsRepository>()),
  );
  getIt.registerFactory<GetSubmission>(
    () => GetSubmission(getIt<SubmissionsRepository>()),
  );
  getIt.registerFactory<UpdateValidationStatus>(
    () => UpdateValidationStatus(getIt<SubmissionsRepository>()),
  );
  // Legacy aggregate access
  getIt.registerFactory<GetFormAssetLegacy>(
    () => GetFormAssetLegacy(getIt<KoboService>()),
  );
}
