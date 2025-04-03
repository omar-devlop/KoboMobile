import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/kobo_utils/safe_index.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/response_data.dart';
import 'package:kobo/data/modules/survey_item.dart';

class KoboFormRepository {
  final String formName;
  final String uid;
  final int deploymentSubmissionCount;
  final List<String> languages;
  final List<SurveyItem> questions;
  final List<ChoicesItem> choices;
  final Map<String, List<String>> variablesMap;
  ResponseData data;

  KoboFormRepository._({
    required this.formName,
    required this.uid,
    required this.deploymentSubmissionCount,
    required dynamic survey,
    required this.languages,
    required this.questions,
    required this.choices,
    required this.variablesMap,
    required this.data,
  });

  static Future<KoboFormRepository> create(dynamic survey) async {
    final formName = survey["name"] ?? '';
    final uid = survey["uid"] ?? '';
    final deploymentSubmissionCount =
        survey["deployment__submission_count"] ?? 0;
    final languages = <String>["XML Values"];
    final questions = <SurveyItem>[];
    final choices = <ChoicesItem>[];
    final variablesMap = <String, List<String>>{
      "_validation_status": ["Validation"],
    };
    final responseData = await ResponseData.empty();

    // Process languages.
    final List<dynamic>? surveyLanguages = survey["summary"]?["languages"];
    if (surveyLanguages == null || surveyLanguages.isEmpty) {
      languages.add("Default Labels");
    } else {
      languages.addAll(surveyLanguages.whereType<String>());
    }
    debugPrint('handleLanguages ---> ${languages.length} : $languages');

    // Process survey questions.
    final surveyQuestions = survey["content"]?["survey"];
    if (surveyQuestions != null) {
      questions.addAll(
        surveyQuestions.map<SurveyItem>((json) => SurveyItem.fromJson(json)),
      );
    }
    debugPrint('handleSurvey ---> ${questions.length}');

    // Process survey choices.
    final surveyChoices = survey["content"]?["choices"];
    if (surveyChoices != null) {
      choices.addAll(
        surveyChoices.map<ChoicesItem>((json) => ChoicesItem.fromJson(json)),
      );
    }
    debugPrint('handleChoices ---> ${choices.length}');

    // Process labels from both questions and choices.
    for (final question in questions) {
      variablesMap[question.name] = question.labels;
    }
    for (final choice in choices) {
      variablesMap[choice.name] = choice.labels;
    }
    debugPrint('handleLabels ---> ${variablesMap.entries.length}');

    return KoboFormRepository._(
      formName: formName,
      uid: uid,
      deploymentSubmissionCount: deploymentSubmissionCount,
      survey: survey,
      languages: languages,
      questions: questions,
      choices: choices,
      variablesMap: variablesMap,
      data: responseData,
    );
  }

  // dynamic get survey => _survey;

  String getLabel(String name, int languageIndex) {
    return variablesMap[name]?.getIndexOrFirst(languageIndex) ?? name;
  }

  Future<void> fetchData(int pageIndex) async {
    data = await getIt<KoboService>().fetchFormData(
      uid: uid,
      start: pageIndex * Constants.limit,
    );
    return;
  }
}
