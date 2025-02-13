class ChoicesItem {
  late String name;
  late String kuid;
  late List<String> label;
  late String listName;
  String? autovalue;

  ChoicesItem({
    required this.name,
    required this.kuid,
    required this.label,
    required this.listName,
    this.autovalue,
  });

  ChoicesItem.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? json['\$kuid'];
    kuid = json['\$kuid'];

    label = json['label'] is List
        ? [
            json['name'] ?? "",
            ...(json['label'] as List).whereType<String>().cast<String>()
          ]
        : [json['name'] ?? ""];

    listName = json['list_name'] ?? "";
    autovalue = json['\$autovalue'] ?? "";
  }
}
