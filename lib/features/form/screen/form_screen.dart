import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/helpers/help_func.dart';
import 'package:kobo/core/services/download_manager.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/shared/widget/label_widget.dart';
import 'package:kobo/core/shared/widget/sub_features_labels.dart';
import 'package:kobo/core/shared/widget/submission_activity_overview.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/features/form/widget/form_sub_container.dart';
import 'package:kobo/features/form/widget/form_title_container.dart';

class FormScreen extends StatefulWidget {
  final KoboForm kForm;
  const FormScreen({super.key, required this.kForm});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  double? _downloadProgress;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.tr('summary')),
        actions: [
          if (_downloadProgress != null)
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                value: _downloadProgress == 0 ? null : _downloadProgress,
              ),
            ),

          PopupMenuButton<int>(
            itemBuilder: (BuildContext ctx) {
              final patternIconMap = <Pattern, IconData>{
                'xls': FontAwesomeIcons.fileExcel,
                'xml': FontAwesomeIcons.fileCode,
              };
              return widget.kForm.downloads?.asMap().entries.map((entry) {
                    int index = entry.key;
                    var e = entry.value;
                    return PopupMenuItem<int>(
                      value: index,
                      child: Row(
                        children: [
                          FaIcon(
                            patternIconMap[e.format] ?? FontAwesomeIcons.file,
                          ),
                          const ActionsSpacing(),
                          Text(
                            '${context.tr('download')} ${e.format.toUpperCase()}',
                          ),
                        ],
                      ),
                      onTap: () async {
                        if (!mounted) return;
                        setState(() => _downloadProgress = 0.0);

                        String? filePath = await getIt<DownloadManager>()
                            .getOrDownloadFile(
                              e.url,
                              '${widget.kForm.uid}.${e.format}',
                              onProgress: (rec, total) {
                                if (!mounted) return;
                                setState(
                                  () =>
                                      _downloadProgress =
                                          (rec / total * 100)
                                              .truncateToDouble(),
                                );
                              },
                              forceDownload: true,
                              saveInUserDownloadFolder: true,
                            );
                        await getIt<DownloadManager>().openFile(filePath);
                        if (!mounted) return;
                        setState(() {
                          _downloadProgress = null;
                        });
                      },
                    );
                  }).toList() ??
                  [];
            },
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 16.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormTitleContainer(kForm: widget.kForm),
                  const SizedBox(height: 16.0),
                  LabelWidget(
                    title:
                        '${context.tr('modifyDate')}: ${getFormattedTimeAgo(context, widget.kForm.dateModified)}',
                    icon: Icons.edit,
                    backgroundColor: theme.colorScheme.surface,
                  ),
                  const SizedBox(height: 6.0),
                  LabelWidget(
                    title:
                        '${context.tr('createDate')}: ${getFormattedTimeAgo(context, widget.kForm.dateCreated)}',
                    icon: Icons.power_settings_new,
                    backgroundColor: theme.colorScheme.surface,
                  ),
                  const SizedBox(height: 12.0),

                  SubFeaturesLabels(kForm: widget.kForm, showLabel: true),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 6 : 2,
                childAspectRatio: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              delegate: SliverChildListDelegate([
                if (widget.kForm.hasDeployment)
                  FormSubContainer(
                    title: context.tr('table'),
                    bgIcon: Icon(
                      Icons.table_rows_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ).tapScale(
                    enabled: widget.kForm.hasDeployment,
                    onTap:
                        () => context.pushNamed(
                          Routes.tableDataScreen,
                          arguments: widget.kForm,
                        ),
                  ),
                FormSubContainer(
                  title: context.tr('questions'),
                  bgIcon: Icon(
                    Icons.question_answer_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ).tapScale(
                  onTap:
                      () => context.pushNamed(
                        Routes.contentScreen,
                        arguments: [widget.kForm],
                      ),
                ),
                if (widget.kForm.hasDeployment)
                  FormSubContainer(
                    title: context.tr('data'),
                    bgIcon: Icon(
                      Icons.data_array,
                      color: theme.colorScheme.primary,
                    ),
                  ).tapScale(
                    enabled: widget.kForm.hasDeployment,
                    onTap:
                        () => context.pushNamed(
                          Routes.dataScreen,
                          arguments: widget.kForm,
                        ),
                  ),
                if (widget.kForm.hasDeployment)
                  FormSubContainer(
                    title: context.tr('attachments'),
                    bgIcon: Icon(
                      Icons.folder_open_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ).tapScale(
                    onTap:
                        () => context.pushNamed(
                          Routes.attachmentsScreen,
                          arguments: widget.kForm,
                        ),
                  ),
                FormSubContainer(
                  title: context.tr('users'),
                  bgIcon: Icon(
                    Icons.group_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ).tapScale(
                  onTap:
                      () => context.pushNamed(
                        Routes.formUsersScreen,
                        arguments: widget.kForm,
                      ),
                ),
                if (widget.kForm.hasDeployment)
                  FormSubContainer(
                    title: context.tr('reports'),
                    bgIcon: Icon(
                      Icons.receipt_long_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ).tapScale(
                    onTap:
                        () => context.pushNamed(
                          Routes.reportsScreen,
                          arguments: widget.kForm,
                        ),
                  ),
                if (widget.kForm.hasDeployment)
                  FormSubContainer(
                    title: context.tr('versions'),
                    bgIcon: Icon(
                      Icons.history,
                      color: theme.colorScheme.primary,
                    ),
                  ).tapScale(
                    onTap:
                        () => context.pushNamed(
                          Routes.formVersionsScreen,
                          arguments: widget.kForm,
                        ),
                  ),
                if (widget.kForm.deploymentActive)
                  FormSubContainer(
                    title: context.tr('deploymentLinks'),
                    bgIcon: Icon(Icons.link, color: theme.colorScheme.primary),
                  ).tapScale(
                    onTap:
                        () => context.pushNamed(
                          Routes.deploymentLinksScreen,
                          arguments: widget.kForm,
                        ),
                  ),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: SubmissionActivityOverview(kForm: widget.kForm),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24.0)),
        ],
      ),
    );
  }
}
