import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/kobo_user.dart';
import 'package:kobo/data/modules/response_data.dart';
import 'package:kobo/data/modules/submission_data.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:kobo/featuers/users/model/account.dart';
import 'package:kobo/featuers/users/model/account_repository.dart';

class KoboService {
  final Dio _dio;
  KoboService(this._dio);

  late String _serverUrl;
  late KoboUser _user;

  get user => _user;
  get serverUrl => _serverUrl;

  void setServer({required String url}) {
    _serverUrl = url;
    _dio.options.baseUrl = serverUrl;
  }

  Future<bool> removeSavedAccount() async {
    AccountRepository accountRepo = getIt<AccountRepository>();
    accountRepo.removeAccount(
      Account(username: user.username, password: '', serverUrl: serverUrl),
    );

    return true;
  }

  Future<dynamic> fetchUserDetails() async {
    var response = await _dio.get('/me', queryParameters: {'format': 'json'});

    if (response.statusCode == 200) {
      _user = KoboUser.fromJson(response.data);
      // print('extraDetails.name: ${_user.extraDetails.name.toString()}');
      return true;
    } else {
      return 'couldNotLoginResponseCode'.tr(
        args: [response.statusCode.toString()],
      );
    }
  }

  Future<List<KoboForm>> fetchForms() async {
    var response = await _dio.get(
      '/api/v2/assets',
      queryParameters: {'format': 'json', 'q': 'asset_type:survey'},
    );

    if (response.statusCode == 200) {
      List<KoboForm> forms =
          response.data["results"]
              .map<KoboForm>((json) => KoboForm.fromJson(json))
              .toList();

      return forms;
    }

    return [];
  }

  Future<SurveyData> fetchFormAsset({required String uid}) async {
    var response = await _dio.get(
      '/api/v2/assets/$uid',
      queryParameters: {'format': 'json'},
    );

    if (response.statusCode == 200) {
      var responseContentSurvey = response.data["content"]["survey"];
      var responseContentChoices = response.data["content"]["choices"];
      var responseSummaryLanguages = response.data["summary"]["languages"];

      List<SurveyItem> surveyQuestions = [];
      List<ChoicesItem> choicesData = [];
      List<String> surveyLanguages = ["XML Values"];

      if (responseContentSurvey != null) {
        surveyQuestions =
            responseContentSurvey
                .map<SurveyItem>((json) => SurveyItem.fromJson(json))
                .toList();
      }
      if (responseContentChoices != null) {
        choicesData =
            responseContentChoices
                .map<ChoicesItem>((json) => ChoicesItem.fromJson(json))
                .toList();
      }
      if (responseSummaryLanguages != null) {
        if (responseSummaryLanguages.isEmpty) {
          surveyLanguages.add("Default Labels");
        } else {
          responseSummaryLanguages
              .where((item) => item is String)
              .forEach((item) => surveyLanguages.add(item));
        }
      }
      String formName = response.data["name"] ?? '';
      String uid = response.data["uid"] ?? '';
      int deploymentSubmissionCount =
          response.data["deployment__submission_count"] ?? 0;

      return SurveyData(
        formName: formName,
        uid: uid,
        deploymentSubmissionCount: deploymentSubmissionCount,
        survey: surveyQuestions,
        choices: choicesData,
        languages: surveyLanguages,
      );
    }

    return SurveyData();
  }

  Future<List<SurveyItem>> fetchFormContent({required String uid}) async {
    var response = await _dio.get(
      '/api/v2/assets/$uid/content',
      queryParameters: {'format': 'json'},
    );

    if (response.statusCode == 200) {
      List<SurveyItem> data =
          response.data["data"]["survey"]
              .map<SurveyItem>((json) => SurveyItem.fromJson(json))
              .toList();

      return data;
    }

    return [];
  }

  Future<ResponseData> fetchFormData({
    required String uid,
    int start = 0,
    Map<String, dynamic>? additionalQuery,
  }) async {
    Map<String, dynamic> queryParameters = {
      'format': 'json',
      'start': start,
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
      ResponseData responseData = ResponseData(
        count: response.data["count"],
        next: response.data["next"],
        previous: response.data["previous"],
        results:
            response.data["results"]
                .map<SubmissionData>((json) => SubmissionData.fromJson(json))
                .toList(),
      );

      return responseData;
    }

    return ResponseData(count: 0, results: []);
  }
}
