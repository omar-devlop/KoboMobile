import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/features/settings/widget/settings_tile_widget.dart';

class LanguageSettingWidget extends StatelessWidget {
  const LanguageSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsTileWidget(
      title: context.tr(context.locale.languageCode),
      leading: const Icon(Icons.language),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.pushNamed(Routes.languagesScreen),
    );
  }
}
