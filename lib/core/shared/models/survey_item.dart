import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/helpers/extensions.dart';

class SurveyItem {
  late String name;
  late QuestionType type;
  late String kuid;
  late String qpath;
  late String xpath;
  String? autoname;
  late List<String> labels;
  late bool isRequired;
  String? selectFromListName;

  SurveyItem({
    required this.name,
    required this.type,
    required this.kuid,
    required this.qpath,
    required this.xpath,
    this.autoname,
    required this.labels,
    required this.isRequired,
    this.selectFromListName,
  });

  SurveyItem.fromJson(Map<String, dynamic> json) {
    name = json['\$autoname'] ?? json['name'] ?? json['\$kuid'];
    type = (json['type'].split(' ')[0] as String).toQuestionType();
    kuid = json['\$kuid'];
    qpath = json['\$qpath'] ?? "";
    xpath = json['\$xpath'] ?? "";
    autoname = json['\$autoname'] ?? "";
    labels =
        json['label'] is List
            ? [
              name,
              ...(json['label'] as List).whereType<String>().cast<String>(),
            ]
            : [name];
    isRequired =
        json['required'] == null
            ? false
            : json['required'].toString() == 'true'
            ? true
            : false;
    selectFromListName = json['select_from_list_name'] ?? "";
  }
}
