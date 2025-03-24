import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/featuers/settings/widget/language_setting_widget.dart';
import 'package:kobo/featuers/settings/widget/theme_color_setting_widget.dart';
import 'package:kobo/featuers/settings/widget/theme_mode_setting_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('settings'))),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          SizedBox(height: 16),
          LanguageSettingWidget(),
          SizedBox(height: 8),
          ThemeModeSettingWidget(),
          SizedBox(height: 8),
          ThemeColorSettingWidget(),
        ],
      ),
    );
  }
}
