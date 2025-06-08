import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kobo/core/services/cloudflare_service.dart';
import 'package:kobo/core/services/pdf_service.dart';
import 'package:kobo/core/utils/networking/dio_factory.dart';
import 'package:kobo/features/users/model/account_repository.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/services/download_manager.dart';

final getIt = GetIt.instance;

/// Sets up the application's dependencies via GetIt.
Future<void> setupGetIt() async {
  // Create a shared Dio instance
  Dio dio = DioFactory.getDio();

  // Register services and repositories
  getIt.registerLazySingleton<KoboService>(() => KoboService(dio));
  getIt.registerLazySingleton<AccountRepository>(() => AccountRepository());
  getIt.registerSingletonAsync<PdfService>(() async {
    final service = PdfService();
    await service.initService();
    return service;
  });

  // Register the DownloadManager to handle file downloads & openings
  getIt.registerLazySingleton<DownloadManager>(() => DownloadManager(dio));

  getIt.registerLazySingleton<CloudflareService>(() => CloudflareService());
}
