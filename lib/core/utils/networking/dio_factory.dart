import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:convert';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio(
        BaseOptions(
          // baseUrl: 'https://eu.kobotoolbox.org',
          validateStatus: (status) => true,
        ),
      );
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      addDioHeaders();
      // addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioHeaders() async {
    dio?.options.headers = {
      'Accept': 'application/json',
      // 'Authorization':
      //     'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
    };
  }

  static String getCredentials({
    required String username,
    required String password,
  }) {
    return base64.encode(utf8.encode('$username:$password'));
  }

  static void setCredentialsIntoHeader({
    required String username,
    required String password,
  }) {
    dio?.options.headers = {
      'Authorization':
          'Basic ${getCredentials(username: username, password: password)}',
    };
  }

  static void removeCredentialsIntoHeader() {
    dio?.options.headers.remove('Authorization');
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        // requestBody: true,
        requestHeader: true,
        responseBody: false,
        // responseHeader: true,
      ),
    );
  }
}
