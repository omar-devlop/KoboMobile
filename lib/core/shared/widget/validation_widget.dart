import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/enums/validation_type.dart';
import 'package:kobo/core/helpers/extensions/validation_type_ext.dart';
import 'package:kobo/core/shared/models/validation_status.dart';

class ValidationWidget extends StatelessWidget {
  final ValidationStatus? validationStatus;
  const ValidationWidget({super.key, required this.validationStatus});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Icon validationIcon = const Icon(
      Icons.do_not_disturb_on,
      color: Colors.white,
    );
    Color validationColor = const Color(0xFF808080);

    String validationLabel = context.tr('notValidated');
    switch (validationStatus.toType()) {
      case ValidationType.approved:
        validationIcon = const Icon(Icons.check_circle, color: Colors.white);
        validationColor = const Color(0xFF00CC66);
        validationLabel = context.tr('approved');
        break;
      case ValidationType.notApproved:
        validationIcon = const Icon(Icons.cancel, color: Colors.white);
        validationColor = const Color(0xFFFF3333);
        validationLabel = context.tr('notApproved');
        break;
      case ValidationType.onHold:
        validationIcon = const Icon(Icons.warning, color: Colors.white);
        validationColor = const Color(0xFFFFA500);
        validationLabel = context.tr('onHold');
        break;
      default:
    }

    return Container(
      height: screenSize.height / 10,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: validationColor,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(width: .5, color: validationColor),
        boxShadow: [
          BoxShadow(
            color: validationColor.withAlpha(50),
            offset: const Offset(0, 4),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 6.0,
        children: [
          validationIcon,
          Text(
            validationLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
