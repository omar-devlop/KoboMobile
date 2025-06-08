import 'package:flutter/material.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';

class SurveyLanguageSelector extends StatelessWidget {
  final KoboFormRepository survey;
  final int selectedLangIndex;
  final Function(int) onSelected;
  final List<PopupMenuEntry<int>> extraItems;
  final bool showDivider;
  const SurveyLanguageSelector({
    super.key,
    required this.survey,
    this.selectedLangIndex = 1,
    required this.onSelected,
    this.extraItems = const [],
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: selectedLangIndex,
      itemBuilder: (BuildContext context) {
        return [
          ...extraItems,
          if (extraItems.isNotEmpty && showDivider) const PopupMenuDivider(),
          ...List<PopupMenuEntry<int>>.generate(
            survey.languages.length,
            (i) => CheckedPopupMenuItem<int>(
              value: i,
              checked: selectedLangIndex == i,
              child: Text(survey.languages[i]),
            ),
          ),
        ];
      },
      onSelected: onSelected,
    );
  }
}
