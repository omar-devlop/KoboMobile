import 'package:flutter/material.dart';

Widget getValidationStatusIcon({String? validationLabel}) {
  if (validationLabel != null) {
    switch (validationLabel) {
      case 'Approved':
        return Icon(Icons.done, color: Colors.green);
      case 'On Hold':
        return Icon(Icons.priority_high, color: Colors.orange);
      case 'Not Approved':
        return Icon(Icons.close, color: Colors.red);
      default:
    }
  }
  return SizedBox.shrink();
}

Color? getValidationStatusColor({String? validationLabel}) {
  if (validationLabel != null) {
    switch (validationLabel) {
      case 'Approved':
        return Colors.green.shade50.withAlpha(100);
      case 'On Hold':
        return Colors.orange.shade50.withAlpha(100);
      case 'Not Approved':
        return Colors.red.shade50.withAlpha(100);
      default:
    }
  }
  return null;
}

// import 'package:flutter/material.dart';
// import 'package:kobo/core/enums/validation_types.dart';
// import 'package:kobo/data/modules/validation_status.dart';

// extension Validation on ValidationStatus? {
//   ValidationTypes toValue() {
//     if (this == null) return ValidationTypes.notValidated;

//     switch (this!.uid) {
//       case 'validation_status_approved':
//         return ValidationTypes.approved;
//       case 'validation_status_on_hold':
//         return ValidationTypes.onHold;
//       case 'validation_status_not_approved':
//         return ValidationTypes.notApproved;
//       default:
//         return ValidationTypes.notValidated;
//     }
//   }

//   Icon toIcon() {
//     if (this == null) return Icon(Icons.do_not_disturb_on, color: Colors.grey);

//     switch (this!.uid) {
//       case 'validation_status_approved':
//         return Icon(Icons.check_circle, color: Colors.green);
//       case 'validation_status_on_hold':
//         return Icon(Icons.error, color: Colors.orange);
//       case 'validation_status_not_approved':
//         return Icon(Icons.cancel, color: Colors.red);
//       default:
//         return Icon(Icons.do_not_disturb_on, color: Colors.grey);
//     }
//   }

// }
