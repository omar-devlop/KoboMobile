class SurveyItem {
  late String name;
  late String type;
  late String kuid;
  String? qpath;
  String? xpath;
  String? autoname;
  late List<String> labels;
  late bool isRequired;
  String? selectFromListName;

  SurveyItem({
    required this.name,
    required this.type,
    required this.kuid,
    this.qpath,
    this.xpath,
    this.autoname,
    required this.labels,
    required this.isRequired,
    this.selectFromListName,
  });

  SurveyItem.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? json['\$autoname'] ?? json['\$kuid'];
    type = json['type'].split(' ')[0];
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
            : json['required'] == 'true'
            ? true
            : false;
    selectFromListName = json['select_from_list_name'] ?? "";
  }
}
