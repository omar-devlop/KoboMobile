import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';

class LanguageSettingWidget extends StatelessWidget {
  const LanguageSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.onInverseSurface,
      ),
      child: ListTile(
        title: Text(
          context.tr(context.locale.languageCode),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.language),
        iconColor: theme.colorScheme.primary,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.pushNamed(Routes.languagesScreen),
      ),
    );
  }
}
