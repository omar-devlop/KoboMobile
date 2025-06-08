import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kobo/core/helpers/preferences_service.dart';
import 'package:kobo/core/services/download_manager.dart';
import 'package:kobo/core/shared/widget/confirm_dialog.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/features/settings/widget/language_setting_widget.dart';
import 'package:kobo/features/settings/widget/settings_tile_widget.dart';
import 'package:kobo/features/settings/widget/theme_color_setting_widget.dart';
import 'package:kobo/features/settings/widget/theme_mode_setting_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('settings'))),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        children: [
          const SizedBox(height: 16.0),
          const LanguageSettingWidget(),
          const SizedBox(height: 8.0),
          const ThemeModeSettingWidget(),
          const SizedBox(height: 8.0),
          const ThemeColorSettingWidget(),
          const SizedBox(height: 8.0),
          SettingsTileWidget(
            title: context.tr('cleanCache'),
            leading: const Icon(FontAwesomeIcons.broom),
            onTap: () async {
              await DefaultCacheManager().emptyCache();
              await getIt<DownloadManager>().clearDownloadFolder();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.tr('cacheCleaned'))),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ),
            child: Text(
              context.tr('cleanCacheDescription'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          SettingsTileWidget(
            title: context.tr('clearSavedPreferences'),
            leading: const Icon(Icons.delete_forever),
            containerColor: theme.colorScheme.errorContainer,
            iconColor: theme.colorScheme.error,
            textColor: theme.colorScheme.error,
            onTap: () async {
              bool? result = await showConfirmationDialog(
                context: context,
                onConfirm: PreferencesService.clearAllSavedPreferences,
                title: context.tr("clearSavedPreferences"),
              );
              if (result == true) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('savedPreferencesCleaned')),
                    ),
                  );
                }
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ),
            child: Text(
              context.tr('clearSavedPreferencesDescription'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
