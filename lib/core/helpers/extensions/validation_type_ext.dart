import 'package:flutter/material.dart';
import 'package:kobo/core/enums/validation_type.dart';
import 'package:kobo/core/shared/models/validation_status.dart';

extension ValidationStatusExtension on ValidationStatus? {
  ValidationType toType() {
    if (this == null) return ValidationType.notValidated;
    switch (this!.label) {
      case 'Approved':
        return ValidationType.approved;
      case 'On Hold':
        return ValidationType.onHold;
      case 'Not Approved':
        return ValidationType.notApproved;
      default:
        return ValidationType.notValidated;
    }
  }
}

extension ValidationTypeExtension on ValidationType? {
  String get toApiValue {
    switch (this) {
      case ValidationType.approved:
        return 'validation_status_approved';
      case ValidationType.onHold:
        return 'validation_status_on_hold';
      case ValidationType.notApproved:
        return 'validation_status_not_approved';
      default:
        return '';
    }
  }

  String get toValue {
    switch (this) {
      case ValidationType.approved:
        return 'approved';
      case ValidationType.onHold:
        return 'onHold';
      case ValidationType.notApproved:
        return 'notApproved';
      default:
        return 'notValidated';
    }
  }

  Widget toIcon() {
    switch (this) {
      case ValidationType.approved:
        return const Icon(Icons.check_circle, color: Color(0xFF00CC66));
      case ValidationType.onHold:
        return const Icon(Icons.warning, color: Color(0xFFFFA500));
      case ValidationType.notApproved:
        return const Icon(Icons.cancel, color: Color(0xFFFF3333));
      default:
        return const Icon(Icons.do_not_disturb_on, color: Colors.grey);
    }
  }

  Color toColor() {
    switch (this) {
      case ValidationType.approved:
        return const Color(0xFF00CC66);
      case ValidationType.onHold:
        return const Color(0xFFFFA500);
      case ValidationType.notApproved:
        return const Color(0xFFFF3333);
      default:
        return Colors.grey;
    }
  }
}
