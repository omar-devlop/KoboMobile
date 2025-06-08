import 'package:flutter/material.dart';

Widget getValidationStatusIcon({String? validationLabel}) {
  if (validationLabel != null) {
    switch (validationLabel) {
      case 'Approved':
        return const Icon(Icons.check_circle, color: Color(0xFF00CC66));
      case 'On Hold':
        return const Icon(Icons.warning, color: Color(0xFFFFA500));
      case 'Not Approved':
        return const Icon(Icons.cancel, color: Color(0xFFFF3333));
      default:
        return const Icon(Icons.do_not_disturb_on, color: Colors.grey);
    }
  }
  return const Icon(Icons.do_not_disturb_on, color: Colors.grey);
}

Color? getValidationStatusColor({String? validationLabel}) {
  if (validationLabel != null) {
    switch (validationLabel) {
      case 'Approved':
        return Colors.green.withAlpha(25);
      case 'On Hold':
        return Colors.orange.withAlpha(25);
      case 'Not Approved':
        return Colors.red.withAlpha(25);
      default:
    }
  }
  return null;
}
