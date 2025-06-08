import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kobo/core/enums/validation_type.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions/validation_type_ext.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/shared/models/kobo_user.dart';
import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/features/form/model/submission_stats.dart';
import 'package:kobo/features/users/model/account.dart';
import 'package:kobo/features/users/model/account_repository.dart';

//  Using GET vs POST for login	You appear to be invoking login via a GET (“login-by-email?app_locale=en”). GET requests can be cached or logged in browser history, proxies, etc., potentially exposing credentials (if any) or tokens.	Always perform authentication operations via POST. That prevents intermediate systems from caching sensitive URLs.

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
    try {
      var response = await _dio.get('/me', queryParameters: {'format': 'json'});

      if (response.statusCode == 200) {
        _user = KoboUser.fromJson(response.data);
        return true;
      } else {
        return 'couldNotLoginResponseCode'.tr(
          args: [response.statusCode.toString()],
        );
      }
    } catch (e) {
      return '${'failedLogIn'.tr()}: ${e.toString()}';
    }
  }

  Future<List<dynamic>> fetchInAppMessages() async {
    try {
      var response = await _dio.get('/help/in_app_messages');

      if (response.statusCode == 200) {
        List<dynamic> inAppMessagesList = response.data["results"];

        return inAppMessagesList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
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

  Future<SubmissionStats> fetchFormDailySubmissionCounts({
    required String uid,
    int? days,
  }) async {
    var response = await _dio.get(
      '/api/v2/assets/$uid/counts',
      queryParameters: {'format': 'json', 'days': days ?? 7},
    );
    if (response.statusCode == 200) {
      return SubmissionStats.fromJson(response.data);
    }
    return SubmissionStats.empty();
  }

  Future<KoboFormRepository?> fetchFormAsset({
    required String uid,
    String? versionUid,
  }) async {
    String versionPath = '';
    if (versionUid != null) versionPath = '/versions/$versionUid';

    var response = await _dio.get(
      '/api/v2/assets/$uid$versionPath',
      queryParameters: {'format': 'json'},
    );

    if (response.statusCode == 200) {
      return await KoboFormRepository.create(response.data);
    }

    return null;
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

    // Remove null query to remove limits to load whole data
    for (var key in List<String>.from(queryParameters.keys)) {
      if (queryParameters[key] == null) {
        queryParameters.remove(key);
      }
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

    return ResponseData.empty();
  }

  Future<SubmissionData?> fetchFormSubmissionData({
    required String uid,
    required int id,
  }) async {
    var response = await _dio.get('/api/v2/assets/$uid/data/$id?format=json');
    if (response.statusCode == 200) {
      SubmissionData submissionData = SubmissionData.fromJson(response.data);

      return submissionData;
    }

    return null;
  }

  Future<bool> validatteSubmissionStatus({
    required String uid,
    required List<int> submissionIds,
    required ValidationType validationType,
  }) async {
    try {
      final data = FormData.fromMap({
        'payload':
            '{"submission_ids":[${submissionIds.map((id) => '"$id"').join(',')}],"validation_status.uid":"${validationType.toApiValue}"}',
      });

      var response = await _dio.patch(
        '/api/v2/assets/$uid/data/validation_statuses/',
        data: data,
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
