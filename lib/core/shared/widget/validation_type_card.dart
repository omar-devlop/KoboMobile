import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/enums/validation_type.dart';
import 'package:kobo/core/helpers/extensions/validation_type_ext.dart';

class ValidationTypeCard extends StatelessWidget {
  final ValidationType validationType;
  final bool isLoading;

  const ValidationTypeCard({
    super.key,
    required this.validationType,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),

      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        spacing: 12.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          validationType.toIcon(),
          Expanded(
            child: Text(
              validationType.toValue.tr(),
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
