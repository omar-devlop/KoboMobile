import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/form_data.dart';
import 'package:kobo/data/modules/survey_item.dart';

class SurveyData {
  String formName;
  List<SurveyItem> survey;
  List<ChoicesItem> choices;
  List<SubmissionBasicData> data;
  List<String> languages = [];

  SurveyData({
    this.formName = '',
    this.survey = const [],
    this.choices = const [],
    this.data = const [],
    this.languages = const [],
  });
}
