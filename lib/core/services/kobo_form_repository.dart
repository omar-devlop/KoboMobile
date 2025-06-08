import 'package:flutter/foundation.dart';
import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/helpers/extensions/safe_index_ext.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/models/attachment.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/shared/models/choices_item.dart';
import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/shared/models/survey_item.dart';

class KoboFormRepository {
  final KoboForm form;
  final List<String> languages;
  final List<SurveyItem> questions;
  final List<ChoicesItem> choices;
  final Map<String, List<String>> variablesMap;
  ResponseData responseData;

  KoboFormRepository._({
    required this.form,
    required this.languages,
    required this.questions,
    required this.choices,
    required this.variablesMap,
    required this.responseData,
  });

  static Future<KoboFormRepository> create(dynamic survey) async {
    void checkAndAddLabels({
      required List<dynamic> items,
      required Map<String, List<String>> variablesMap,
    }) {
      for (final item in items) {
        final key = item.name;
        final newLabels = item.labels;

        if (!variablesMap.containsKey(key)) {
          // Key doesn't exist yet — just add it
          variablesMap[key] = List<String>.from(newLabels);
        }
        //  else {
        // Key exists — check each incoming label
        // final existingLabels = variablesMap[key]!;

        // for (final label in newLabels) {
        //   if (!existingLabels.contains(label)) {
        //     if (kDebugMode) {
        //       debugPrint(
        //         '⚠️ Issue: label "$label" for "$key" '
        //         'does not exist in variablesMap.',
        //       );
        //     }
        //   }
        // }
        // }
      }
    }

    final form = KoboForm.fromJson(survey);

    final languages = <String>["XML Values"];
    final questions = <SurveyItem>[];
    final choices = <ChoicesItem>[];
    final variablesMap = <String, List<String>>{
      "_validation_status": ["Validation"],
    };
    final responseData = ResponseData.empty();

    // Process languages.
    final List<dynamic>? surveyLanguages = survey["summary"]?["languages"];
    if (surveyLanguages == null || surveyLanguages.isEmpty) {
      languages.add("Default Labels");
    } else {
      languages.addAll(surveyLanguages.whereType<String>());
    }
    // debugPrint('handleLanguages ---> ${languages.length} : $languages');

    // Process survey questions.
    final surveyQuestions = survey["content"]?["survey"];
    if (surveyQuestions != null) {
      questions.addAll(
        surveyQuestions.map<SurveyItem>((json) => SurveyItem.fromJson(json)),
      );
    }
    // debugPrint('handleSurvey ---> ${questions.length}');

    // Process survey choices.
    final surveyChoices = survey["content"]?["choices"];
    if (surveyChoices != null) {
      choices.addAll(
        surveyChoices.map<ChoicesItem>((json) => ChoicesItem.fromJson(json)),
      );
    }
    // debugPrint('handleChoices ---> ${choices.length}');

    checkAndAddLabels(items: questions, variablesMap: variablesMap);

    checkAndAddLabels(items: choices, variablesMap: variablesMap);

    // debugPrint('handleLabels ---> ${variablesMap.entries.length}');

    return KoboFormRepository._(
      form: form,
      languages: languages,
      questions: questions,
      choices: choices,
      variablesMap: variablesMap,
      responseData: responseData,
    );
  }

  Map<String, dynamic>? _additionalQuery;
  int languageIndex = 1;

  /// Get label set `columnName` to force it to check field column type
  String getLabel(String name, {String? columnName}) {
    if (columnName is String) {
      QuestionType columnType = getType(columnName);
      if (columnType.isMultiChoice) {
        return getMultiLabel(name);
      }
    }
    return variablesMap[name]?.getIndexOrFirst(languageIndex) ?? name;
  }

  String getMultiLabel(String name, {String divider = " "}) {
    String multiLabelValue = name
        .split(divider)
        .map((val) => getLabel(val))
        .join(divider);
    return multiLabelValue;
  }

  QuestionType getType(String columnName) {
    int questionIndex = questions.indexWhere((q) => q.name == columnName);
    if (questionIndex >= 0) {
      return questions[questionIndex].type;
    }
    return QuestionType.text;
  }

  bool isImageQuestion(String columnName) {
    return getType(columnName) == QuestionType.image;
  }

  List<Attachment> getImageAttachments(int submissionIndex) {
    return responseData.results[submissionIndex].attachments
        .where(
          (element) => isImageQuestion(element.questionXpath.lastAfterSlash),
        )
        .toList();
  }

  bool isMediaQuestion(String columnName) {
    return getType(columnName).isMedia;
  }

  bool isSelectionQuestion(String columnName) {
    return getType(columnName).isSelection;
  }

  Future<void> fetchData({
    int pageIndex = 0,
    Map<String, dynamic>? additionalQuery,
  }) async {
    _additionalQuery = additionalQuery;
    responseData = await getIt<KoboService>().fetchFormData(
      uid: form.uid,
      start: pageIndex * Constants.limit,
      additionalQuery: _additionalQuery,
    );
    handleDataWithQuestions();
    return;
  }

  Future<void> fetchMoreData() async {
    if (responseData.count <= responseData.results.length) return;

    ResponseData newData = await getIt<KoboService>().fetchFormData(
      uid: form.uid,
      start: responseData.results.length,
      additionalQuery: _additionalQuery,
    );

    responseData.results.addAll(newData.results);
    handleDataWithQuestions();
    return;
  }

  Future<void> fetchWholeData({Map<String, dynamic>? additionalQuery}) async {
    responseData = ResponseData.empty();
    responseData.next = '';

    additionalQuery ??= {};
    additionalQuery.addAll({'limit': null});

    while (responseData.next != null) {
      ResponseData newResponseData = await getIt<KoboService>().fetchFormData(
        uid: form.uid,
        start: responseData.results.length,
        additionalQuery: additionalQuery,
      );

      responseData.count = newResponseData.count;
      responseData.next = newResponseData.next;
      responseData.previous = newResponseData.previous;
      responseData.results.addAll(newResponseData.results);
      debugPrint('Fetched whole data: ${responseData.results.length}');
    }

    handleDataWithQuestions();

    return;
  }

  handleDataWithQuestions() {
    for (SubmissionData item in responseData.results) {
      for (var entry in item.data.entries) {
        int questionIndex = questions.indexWhere(
          (element) => element.name == entry.key,
        );
        if (questionIndex >= 0) {
          entry.value.fieldType = questions[questionIndex].type;
        }
      }
    }
  }

  String interpolate(String template, SubmissionData data) {
    final reg = RegExp(r'\$\{([^}]+)\}');
    return template.replaceAllMapped(reg, (match) {
      final key = match.group(1)!;
      String replacement = data.data[key]?.fieldValue ?? "";

      return getLabel(replacement, columnName: key);
    });
  }

  Future<bool> reFetchSubmissions(List<int> ids) async {
    if (ids.isEmpty) return true;

    // Build the query for `_id` in [list of ids]
    final query = {
      'query': {
        '_id': {r'$in': ids},
      },
    };

    try {
      final ResponseData newResponse = await getIt<KoboService>().fetchFormData(
        uid: form.uid,
        additionalQuery: query,
      );

      // Replace matching old submissions with updated ones
      for (var newSubmission in newResponse.results) {
        final index = responseData.results.indexWhere(
          (element) => element.id == newSubmission.id,
        );

        if (index >= 0) {
          responseData.results[index] = newSubmission;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
