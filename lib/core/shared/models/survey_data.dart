import 'package:kobo/core/shared/models/choices_item.dart';
import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/shared/models/survey_item.dart';

class SurveyData {
  String formName;
  String uid;
  int deploymentSubmissionCount;
  List<SurveyItem> survey;
  List<ChoicesItem> choices;
  ResponseData? data;
  List<String> languages = [];

  SurveyData({
    this.formName = '',
    this.uid = '',
    this.deploymentSubmissionCount = 0,
    this.survey = const [],
    this.choices = const [],
    this.data,
    this.languages = const [],
  });
}
