import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/shared/widget/sub_features_labels.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';

class KoboFormCard extends StatelessWidget {
  final KoboForm kForm;
  const KoboFormCard({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 4.0,
        left: 12,
        right: 12,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: theme.colorScheme.onInverseSurface),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  kForm.name,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ],
          ),
          if (!kForm.settings!.description.isNullOrEmpty())
            Text(
              kForm.settings!.description,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          if (kForm.deploymentSubmissionCount != null && kForm.hasDeployment)
            Text(
              kForm.deploymentSubmissionCount.toString(),
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(child: SubFeaturesLabels(kForm: kForm)),

              IconButton(
                color: theme.colorScheme.primary,
                onPressed:
                    () => context.pushNamed(
                      Routes.contentScreen,
                      arguments: [kForm],
                    ),
                icon: const Icon(Icons.question_answer_outlined),
                tooltip: context.tr('questions'),
              ),
              if (kForm.hasDeployment)
                IconButton(
                  color: theme.colorScheme.primary,
                  onPressed:
                      () => context.pushNamed(
                        Routes.dataScreen,
                        arguments: kForm,
                      ),
                  icon: const Icon(Icons.data_array),
                  tooltip: context.tr('data'),
                ),
            ],
          ),
        ],
      ),
    ).tapScale(
      onTap: () => context.pushNamed(Routes.formScreen, arguments: kForm),
    );
  }
}
