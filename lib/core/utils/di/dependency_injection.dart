import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kobo/core/utils/networking/dio_factory';
import 'package:kobo/data/services/kobo_service.dart';
import 'package:kobo/featuers/users/model/account_repository.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  Dio dio = DioFactory.getDio();

  getIt.registerLazySingleton<KoboService>(() => KoboService(dio));
  getIt.registerLazySingleton<AccountRepository>(() => AccountRepository());
  // getIt.registerLazySingleton<GeminiService>(() => GeminiService());
}
