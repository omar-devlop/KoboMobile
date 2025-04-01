
class ValidationStatus {
  int? timestamp;
  String? uid;
  String? byWhom;
  String? color;
  String? label;

  ValidationStatus({
    this.timestamp,
    this.uid,
    this.byWhom,
    this.color,
    this.label,
  });

  ValidationStatus.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'] ?? 0;
    uid = json['uid'] ?? "";
    byWhom = json['by_whom'] ?? "";
    color = json['color'] ?? "";
    label = json['label'] ?? "";
  }
}
