class ValidationStatus {
  late int timestamp;
  late String uid;
  late String byWhom;
  late String color;
  late String label;

  ValidationStatus({
    required this.timestamp,
    required this.uid,
    required this.byWhom,
    required this.color,
    required this.label,
  });

  ValidationStatus.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'] ?? 0;
    uid = json['uid'] ?? "";
    byWhom = json['by_whom'] ?? "";
    color = json['color'] ?? "";
    label = json['label'] ?? "";
  }
}
