import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions/app_theme.dart';
import 'package:kobo/features/about/model/github_release.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersionWidget extends StatelessWidget {
  final GitHubRelease newRelease;
  const NewVersionWidget({super.key, required this.newRelease});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              newRelease.name,
              style: context.texts.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.secondary,
              ),
            ),
            IconButton.filled(
              onPressed: () async {
                try {
                  await launchUrl(Uri.parse(newRelease.htmlUrl));
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        Text(
          newRelease.body,
          style: context.texts.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.secondary,
          ),
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
