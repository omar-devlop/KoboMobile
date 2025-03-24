import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('chooseLanguage'))),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: context.supportedLocales.length,
        itemBuilder: (context, index) {
          Locale sLocale = context.supportedLocales[index];

          return RadioListTile(
            value: sLocale,
            groupValue: context.locale,
            title: Text(context.tr(sLocale.languageCode)),
            onChanged: (value) {
              context.setLocale(sLocale);
            },
          );
        },
      ),
    );
  }
}
