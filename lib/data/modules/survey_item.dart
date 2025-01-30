class SurveyItem {
  String? name;
  late String type;
  late String kuid;
  String? qpath;
  String? xpath;

  SurveyItem({
    this.name,
    required this.type,
    required this.kuid,
    this.qpath,
    this.xpath,
  });

  SurveyItem.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    type = json['type'].split(' ')[0];
    kuid = json['\$kuid'];
    qpath = json['\$qpath'] ?? "";
    xpath = json['\$xpath'] ?? "";
  }
}
