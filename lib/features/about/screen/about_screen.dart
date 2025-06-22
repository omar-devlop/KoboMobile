import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions/app_theme.dart';
import 'package:kobo/core/shared/widget/page_background.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sized_context/sized_context.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: context.colors.primary,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),

      body: Stack(
        children: [
          const PageBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 72),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/kobo_logo.svg',
                    width: context.sizePx.width / 1.5,
                  ),
                  const SizedBox(height: 72),

                  Text(
                    getIt<PackageInfo>().appName,
                    style: context.texts.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.secondary,
                    ),
                  ),
                  Text(
                    getIt<PackageInfo>().version,
                    style: context.texts.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.secondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    label: Text(context.tr('joinTelegramGroup')),
                    onPressed: () async {
                      try {
                        await launchUrl(
                          Constants.telegramGroupUrl,
                          mode: LaunchMode.platformDefault,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                    icon: const Icon(FontAwesomeIcons.telegram),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
