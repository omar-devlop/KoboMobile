import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/features/ai/widget/ai_sheet.dart';

class FormTitleContainer extends StatelessWidget {
  final KoboForm kForm;
  const FormTitleContainer({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          width: screenSize.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.outline,
                theme.colorScheme.outlineVariant,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  kForm.deploymentSubmissionCount != null && kForm.hasDeployment
                      ? kForm.deploymentSubmissionCount.toString()
                      : '-',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  kForm.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              highlightColor: Colors.transparent,
              onPressed:
                  () => openAiSheet(
                    context,
                    title: tr("suggestedTitles"),
                    phrase: kForm.name,
                  ),
              icon: const Icon(Icons.auto_awesome, color: Colors.white),
            ),
          ],
        ),
      ],
    ).tapScale();
  }
}
