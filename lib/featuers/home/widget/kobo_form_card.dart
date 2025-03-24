import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/routing/navigation_route.dart';
import 'package:kobo/core/utils/routing/open_container_navigation.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/data/modules/kobo_user.dart';
import 'package:kobo/data/services/kobo_service.dart';

class KoboFormCard extends StatelessWidget {
  final KoboForm kForm;
  const KoboFormCard({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    KoboUser user = getIt<KoboService>().user;
    ThemeData theme = Theme.of(context);
    return Tooltip(
      message: kForm.name,
      child: OpenContainerNavigation(
        openPage: getPage(pageName: Routes.formScreen, arguments: kForm),
        child:
            (openContainer) => GestureDetector(
              onTap:
                  openContainer, //() => context.pushNamed(Routes.formScreen, arguments: kForm),
              child: Container(
                padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: 12,
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.surfaceContainer, // surfaceContainerLow
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kForm.name,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),

                              Text(
                                user.username == kForm.ownerUsername
                                    ? ''
                                    : kForm.ownerUsername,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall!.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          kForm.deploymentActive
                              ? Icons.rocket_launch
                              : Icons.inventory_2,
                          size: 14,
                          color:
                              kForm.deploymentActive
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        if (kForm.deploymentSubmissionCount != 0)
                          Text(
                            kForm.deploymentSubmissionCount.toString(),
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        Spacer(),
                        IconButton(
                          color: theme.primaryColor,
                          onPressed:
                              () => context.pushNamed(
                                Routes.contentScreen,
                                arguments: kForm,
                              ),
                          icon: Icon(Icons.question_answer_outlined),
                          tooltip: 'Questions',
                        ),
                        if (kForm.hasDeployment)
                          IconButton(
                            color: theme.primaryColor,
                            onPressed:
                                () => context.pushNamed(
                                  Routes.dataScreen,
                                  arguments: kForm,
                                ),
                            icon: Icon(Icons.data_array),
                            tooltip: 'Data',
                          ),
                        if (kForm.hasDeployment)
                          IconButton(
                            color: theme.primaryColor,
                            onPressed:
                                () => context.pushNamed(
                                  Routes.sTableDataScreen,
                                  arguments: kForm,
                                ),
                            icon: Icon(Icons.table_rows_outlined),
                            tooltip: 'Table',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
