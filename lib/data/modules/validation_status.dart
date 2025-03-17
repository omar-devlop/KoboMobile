import 'package:flutter/material.dart';

class ValidationStatus {
  int? timestamp;
  String? uid;
  String? byWhom;
  Color? color;
  String? label;
  Widget? icon;

  ValidationStatus({
    this.timestamp,
    this.uid,
    this.byWhom,
    this.color,
    this.label,
    this.icon,
  });

  ValidationStatus.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'] ?? 0;
    uid = json['uid'] ?? "";
    byWhom = json['by_whom'] ?? "";
    color = getColor(); //json['color'] ?? "";
    label = json['label'] ?? "";
    icon = getIcon();
  }

  Widget getIcon() {
    switch (uid) {
      case 'validation_status_approved':
        return Icon(Icons.done, color: Colors.green);
      case 'validation_status_on_hold':
        return Icon(Icons.priority_high, color: Colors.orange);
      case 'validation_status_not_approved':
        return Icon(Icons.close, color: Colors.red);
      default:
    }
    return SizedBox.shrink();
  }

  Color? getColor() {
    switch (uid) {
      case 'validation_status_approved':
        return Colors.green.shade50.withAlpha(100);
      case 'validation_status_on_hold':
        return Colors.orange.shade50.withAlpha(100);
      case 'validation_status_not_approved':
        return Colors.red.shade50.withAlpha(100);
      default:
    }
    return null;
  }
}
