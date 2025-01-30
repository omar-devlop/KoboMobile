import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kobo/core/utils/networking/dio_factory';
import 'package:kobo/data/services/kobo_service.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();
  DioFactory.setTokenIntoHeaderAfterLogin(
      '5d5483e662e150734a690ccacec834bc25a3474b');

  getIt.registerLazySingleton<KoboService>(() => KoboService(dio));
}
