import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/survey_item.dart';

class SurveyData {
  late List<SurveyItem> survey;
  late List<ChoicesItem> choices;

  SurveyData({
    required this.survey,
    required this.choices,
  });
}
