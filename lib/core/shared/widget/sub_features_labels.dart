import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/widget/label_widget.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

class SubFeaturesLabels extends StatelessWidget {
  final bool showLabel;
  const SubFeaturesLabels({
    super.key,
    required this.kForm,
    this.showLabel = false,
  });

  final KoboForm kForm;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: <Widget>[
        LabelWidget(
          title:
              kForm.deploymentActive
                  ? context.tr('deployed')
                  : kForm.deploymentStatus == 'archived'
                  ? context.tr('archived')
                  : context.tr('draft'),
          icon:
              kForm.deploymentActive
                  ? Icons.rocket_launch
                  : kForm.deploymentStatus == 'archived'
                  ? Icons.inventory_2
                  : Icons.edit_document,
          forgroundColor:
              kForm.deploymentActive
                  ? theme.colorScheme.primary
                  : kForm.deploymentStatus == 'archived'
                  ? theme.colorScheme.error
                  : theme.colorScheme.outline,
          backgroundColor:
              kForm.deploymentActive
                  ? theme.colorScheme.primaryContainer
                  : kForm.deploymentStatus == 'archived'
                  ? theme.colorScheme.errorContainer
                  : theme.colorScheme.outlineVariant,
          showLabel: showLabel,
        ),
        if (getIt<KoboService>().user.username != kForm.ownerUsername)
          LabelWidget(
            title: kForm.ownerUsername,
            icon: Icons.person,
            forgroundColor: theme.colorScheme.secondary,
            backgroundColor: theme.colorScheme.secondaryContainer,
            showLabel: showLabel,
          ),
        if (!kForm.hasDeployment)
          LabelWidget(
            title: context.tr("fresh"),
            icon: Icons.auto_awesome,
            forgroundColor: theme.colorScheme.tertiary,
            backgroundColor: theme.colorScheme.tertiaryContainer,
            showLabel: showLabel,
          ),

        if (kForm.summary.geo == true)
          LabelWidget(
            title: context.tr("geopoint"),
            icon: Icons.location_on,
            forgroundColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primaryContainer,
            showLabel: showLabel,
          ),

        if (kForm.summary.languages.length > 1)
          LabelWidget(
            title: context.tr("multiLanguage"),
            icon: Icons.translate,
            forgroundColor: theme.colorScheme.tertiary,
            backgroundColor: theme.colorScheme.tertiaryContainer,

            showLabel: showLabel,
          ),
        if (!kForm.summary.defaultTranslation.isNullOrEmpty())
          LabelWidget(
            title: kForm.summary.defaultTranslation,
            forgroundColor: theme.colorScheme.tertiary,
            backgroundColor: theme.colorScheme.tertiaryContainer,
          ),

        if (kForm.deploymentSubmissionCount == null)
          LabelWidget(
            title: context.tr("limitedAccess"),
            icon: Icons.shield,
            forgroundColor: theme.colorScheme.error,
            backgroundColor: theme.colorScheme.errorContainer,
            showLabel: showLabel,
          ),
      ],
    );
  }
}
