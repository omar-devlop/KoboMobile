import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  String? title,
  String? content,
  String? confirmText,
  String? cancelText,
  IconData confirmIcon = Icons.check,
  IconData cancelIcon = Icons.close,
  Color? confirmColor,
  required VoidCallback onConfirm,
}) async {
  final theme = Theme.of(context);
  title ??= 'confirmation'.tr();
  content ??= 'areYouSure'.tr();
  confirmText ??= 'ok'.tr();
  cancelText ??= 'cancel'.tr();
  return await showDialog<bool>(
    context: context,
    builder:
        (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(content!),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      label: Text(cancelText!),
                      icon: Icon(cancelIcon),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        iconColor: confirmColor ?? theme.colorScheme.error,
                        foregroundColor:
                            confirmColor ?? theme.colorScheme.error,
                      ),
                      onPressed: () {
                        context.pop(true);
                        onConfirm();
                      },
                      label: Text(confirmText!),
                      icon: Icon(confirmIcon),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
  );
}
