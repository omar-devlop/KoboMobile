import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/helpers/extensions/question_type_ext.dart';
import 'package:kobo/core/helpers/extensions/safe_index_ext.dart';
import 'package:kobo/core/shared/models/attachment.dart';
import 'package:kobo/core/shared/models/choices_item.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/survey_item.dart';

/// Pure aggregate for form content and submissions.
/// No IO or service locator usage. Consumers are responsible for
/// fetching data and populating the aggregate.
class FormAggregator {
  final KoboForm form;
  final List<String> languages;
  final List<SurveyItem> questions;
  final List<ChoicesItem> choices;
  final Map<String, List<String>> variablesMap;
  final dynamic response;

  FormAggregator({
    required this.form,
    required this.languages,
    required this.questions,
    required this.choices,
    required this.variablesMap,
    required this.response,
  });

  int languageIndex = 1;

  String getLabel(String name, {String? columnName}) {
    if (columnName is String) {
      final columnType = getType(columnName);
      if (columnType.isMultiChoice) {
        return getMultiLabel(name);
      }
    }
    return variablesMap[name]?.getIndexOrFirst(languageIndex) ?? name;
  }

  String getMultiLabel(String name, {String divider = " "}) {
    return name.split(divider).map((val) => getLabel(val)).join(divider);
  }

  QuestionType getType(String columnName) {
    final questionIndex = questions.indexWhere((q) => q.name == columnName);
    if (questionIndex >= 0) return questions[questionIndex].type;
    return QuestionType.text;
  }

  bool isImageQuestion(String columnName) =>
      getType(columnName) == QuestionType.image;
  bool isMediaQuestion(String columnName) => getType(columnName).isMedia;
  bool isSelectionQuestion(String columnName) =>
      getType(columnName).isSelection;

  List<Attachment> getImageAttachments(int submissionIndex) {
    return response.results[submissionIndex].attachments
        .where((e) => isImageQuestion(e.questionXpath))
        .toList();
  }

  void annotateFieldTypes() {
    for (final item in response.results) {
      for (final entry in item.data.entries) {
        final questionIndex = questions.indexWhere(
          (element) => element.name == entry.key,
        );
        if (questionIndex >= 0) {
          entry.value.fieldType = questions[questionIndex].type;
        }
      }
    }
  }
}
