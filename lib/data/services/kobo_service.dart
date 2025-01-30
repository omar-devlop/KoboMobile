import 'package:dio/dio.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/data/modules/form_data.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/data/modules/survey_item.dart';

class KoboService {
  final Dio _dio;
  KoboService(this._dio);

  Future<List<KoboForm>> fetchForms() async {
    var response = await _dio.get(
      '/api/v2/assets',
      queryParameters: {
        'format': 'json',
        'q': 'asset_type:survey',
      },
    );

    if (response.statusCode == 200) {
      List<KoboForm> forms = response.data["results"]
          .map<KoboForm>((json) => KoboForm.fromJson(json))
          .toList();

      return forms;
    }

    return [];
  }

  Future<List<SurveyItem>> fetchFormContent({required String uid}) async {
    var response = await _dio.get(
      '/api/v2/assets/$uid/content',
      queryParameters: {
        'format': 'json',
      },
    );

    if (response.statusCode == 200) {
      List<SurveyItem> data = response.data["data"]["survey"]
          .map<SurveyItem>((json) => SurveyItem.fromJson(json))
          .toList();

      return data;
    }

    return [];
  }

  Future<List<SubmissionBasicData>> fetchFormData({
    required String uid,
    Map<String, dynamic>? additionalQuery,
  }) async {
    Map<String, dynamic> queryParameters = {
      'format': 'json',
      'start': 0,
      'sort': '{"_id":-1}',
      'limit': Constants.limit, // handle Limits
    };

    if (additionalQuery != null) {
      queryParameters.addAll(additionalQuery);
    }

    var response = await _dio.get(
      '/api/v2/assets/$uid/data',
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      List<SubmissionBasicData> data = response.data["results"]
          .map<SubmissionBasicData>(
              (json) => SubmissionBasicData.fromJson(json))
          .toList();

      return data;
    }

    return [];
  }
}
