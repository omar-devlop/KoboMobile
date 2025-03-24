import 'package:flutter/material.dart';

class ThemeModeSettingWidget extends StatelessWidget {
  const ThemeModeSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // bool isSystemThemeMode = appSettings.themeMode == ThemeMode.system;
    // bool isLightThemeMode = appSettings.themeMode == ThemeMode.light;
    // bool isDarkThemeMode = appSettings.themeMode == ThemeMode.dark;
    bool isSystemThemeMode = true;
    bool isLightThemeMode = false;
    bool isDarkThemeMode = false;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.onInverseSurface,
      ),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(vertical: 16),
        leading: Icon(Icons.format_paint, color: theme.colorScheme.primary),
        collapsedIconColor: theme.colorScheme.primary,
        initiallyExpanded: true,
        shape: Border(),

        title: Text(
          'texts.themeMode',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Column(
            children: [
              ListTile(
                iconColor: isSystemThemeMode ? theme.colorScheme.primary : null,
                textColor: isSystemThemeMode ? theme.colorScheme.primary : null,
                // onTap:
                // () => ref
                //     .read(settingsProvider.notifier)
                //     .setThemeMode(ThemeMode.system),
                trailing: isSystemThemeMode ? const Icon(Icons.done) : null,
                leading: const Icon(Icons.brightness_auto),
                title: Text('texts.systemTheme'),
              ),
              ListTile(
                iconColor: isLightThemeMode ? theme.colorScheme.primary : null,
                textColor: isLightThemeMode ? theme.colorScheme.primary : null,
                // onTap:
                //     () => ref
                //         .read(settingsProvider.notifier)
                //         .setThemeMode(ThemeMode.light),
                trailing: isLightThemeMode ? const Icon(Icons.done) : null,
                leading: const Icon(Icons.light_mode),
                title: Text('texts.lightTheme'),
              ),
              ListTile(
                iconColor: isDarkThemeMode ? theme.colorScheme.primary : null,
                textColor: isDarkThemeMode ? theme.colorScheme.primary : null,
                // onTap:
                //     () => ref
                //         .read(settingsProvider.notifier)
                //         .setThemeMode(ThemeMode.dark),
                trailing: isDarkThemeMode ? const Icon(Icons.done) : null,
                leading: const Icon(Icons.dark_mode),
                title: Text('texts.darkTheme'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
