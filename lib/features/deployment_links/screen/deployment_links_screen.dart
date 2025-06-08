import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions/widget_animation_ext.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';

import 'package:kobo/features/content/bloc/form_content_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class DeploymentLinksScreen extends StatelessWidget {
  final KoboForm kForm;
  const DeploymentLinksScreen({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          subtitle: Text(kForm.name, overflow: TextOverflow.ellipsis),
          contentPadding: EdgeInsets.zero,
          title: Text(
            context.tr('deploymentLinks'),
            overflow: TextOverflow.ellipsis,
          ),
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
            success: (data) {
              if (data.form.deploymentLinks.isEmpty) {
                return Center(
                  child: Text(
                    context.tr('noDeploymentLinksFound'),
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                );
              }
              const List<String> linksKeys = [
                "offline_url",
                "url",
                "single_url",
                "single_once_url",
                "preview_url",
              ];

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 32.0,
                ),
                itemCount: linksKeys.length,
                itemBuilder: (context, index) {
                  final String key = linksKeys[index];
                  final MapEntry<String, String> entry = data
                      .form
                      .deploymentLinks
                      .entries
                      .firstWhere((element) => element.key == key);

                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: theme.colorScheme.onInverseSurface,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('${entry.key}.submission_type'),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  context.tr('${entry.key}.access_mode'),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              tooltip: context.tr('copyLink'),
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: entry.value),
                                );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.tr('copiedToClipboard'),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.link),
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),

                        const SizedBox(height: 4.0),

                        Text(
                          context.tr('${entry.key}.description'),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          entry.value,
                          textDirection: TextDirection.ltr,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ).tapScale(
                    onTap: () async {
                      if (await launchUrl(
                        Uri.parse(entry.value),
                        mode: LaunchMode.platformDefault,
                      )) {
                        return true;
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.tr('errorOpenLink')),
                            ),
                          );
                        }
                        return false;
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
