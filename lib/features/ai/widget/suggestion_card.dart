import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kobo/core/helpers/extensions.dart';

class SuggestionCard extends StatelessWidget {
  final String title;
  const SuggestionCard({super.key, required this.title});

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
          Icon(Icons.auto_awesome, color: theme.colorScheme.primary),

          Expanded(
            child: Text(
              title,
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          Icon(Icons.copy_rounded, size: 16, color: theme.colorScheme.primary),
        ],
      ),
    ).tapScale(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: title));
        if (!context.mounted) return;
        context.pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Copied: $title')));
      },
    );
  }
}
