import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions/build_context_ext.dart';
import 'package:kobo/core/helpers/extensions/widget_animation_ext.dart';
import 'package:kobo/core/helpers/help_func.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/widget/label_widget.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/features/content/bloc/form_content_cubit.dart';

class FormVersionsScreen extends StatelessWidget {
  final KoboForm kForm;
  const FormVersionsScreen({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          subtitle: Text(kForm.name, overflow: TextOverflow.ellipsis),
          contentPadding: EdgeInsets.zero,
          title: Text(context.tr('versions'), overflow: TextOverflow.ellipsis),
        ),
      ),
      body: BlocBuilder<FormContentCubit, FormContentState>(
        builder: (context, state) {
          return state.when(
            error: (error) => Center(child: Text(error)),
            loading:
                (msg) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12.0,
                    children: [
                      const CircularProgressIndicator(),
                      Text(
                        msg,
                        style: TextStyle(color: theme.colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
            success:
                (survey) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 48.0,
                  ),
                  itemCount: survey.form.deployedVersions?.count ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Version kVersion =
                        survey.form.deployedVersions!.results[index];
                    bool isCurrentVersion =
                        kVersion.uid == survey.form.deployedVersionId;

                    int versionIndex =
                        survey.form.deployedVersions!.count - index;
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      height:
                          isCurrentVersion
                              ? screenSize.height / 6
                              : screenSize.height / 10,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color:
                              isCurrentVersion
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onInverseSurface,
                        ),
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
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$versionIndex',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                              if (isCurrentVersion)
                                LabelWidget(
                                  title: context.tr('currentVersion'),
                                  icon: Icons.rocket_launch,
                                  backgroundColor: theme.colorScheme.surface,
                                ),
                            ],
                          ),
                          Text(
                            kVersion.uid,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                getFormattedTimeAgo(
                                  context,
                                  kVersion.dateDeployed,
                                ),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).tapScale(
                      onTap:
                          () => context.pushNamed(
                            Routes.contentScreen,
                            arguments: [kForm, kVersion.uid],
                          ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        child: Icon(
                          Icons.expand_less,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    );
                  },
                ),
          );
        },
      ),
    );
  }
}
