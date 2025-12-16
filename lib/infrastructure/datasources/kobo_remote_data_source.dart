import 'package:dio/dio.dart';

class KoboRemoteDataSource {
  final Dio _dio;
  KoboRemoteDataSource(this._dio);

  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  Future<Response> getMe() async {
    return _dio.get('/me', queryParameters: {'format': 'json'});
  }

  Future<Response> getInAppMessages() async {
    return _dio.get('/help/in_app_messages');
  }

  Future<Response> getForms() async {
    return _dio.get(
      '/api/v2/assets',
      queryParameters: {'format': 'json', 'q': 'asset_type:survey'},
    );
  }

  Future<Response> getFormDailySubmissionCounts(String uid, {int? days}) async {
    return _dio.get(
      '/api/v2/assets/$uid/counts',
      queryParameters: {'format': 'json', 'days': days ?? 7},
    );
  }

  Future<Response> getFormContent(String uid) async {
    return _dio.get(
      '/api/v2/assets/$uid/content',
      queryParameters: {'format': 'json'},
    );
  }

  Future<Response> getFormData(String uid, Map<String, dynamic> query) async {
    return _dio.get('/api/v2/assets/$uid/data', queryParameters: query);
  }

  Future<Response> getFormSubmission(String uid, int id) async {
    return _dio.get('/api/v2/assets/$uid/data/$id', queryParameters: {'format': 'json'});
  }

  Future<Response> patchValidationStatus(String uid, FormData data) async {
    return _dio.patch('/api/v2/assets/$uid/data/validation_statuses/', data: data);
  }
}


