class ChoicesItem {
  late String name;
  late String kuid;
  late List<String> labels;
  late String listName;
  String? autovalue;

  ChoicesItem({
    required this.name,
    required this.kuid,
    required this.labels,
    required this.listName,
    this.autovalue,
  });

  ChoicesItem.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? json['\$kuid'];
    kuid = json['\$kuid'] ?? "";

    labels =
        json['label'] is List
            ? [
              json['name'] ?? "",
              ...(json['label'] as List).whereType<String>().cast<String>(),
            ]
            : [json['name'] ?? ""];

    listName = json['list_name'] ?? "";
    autovalue = json['\$autovalue'] ?? "";
  }
}
