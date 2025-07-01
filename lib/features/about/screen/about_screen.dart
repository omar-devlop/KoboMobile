import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions/app_theme.dart';
import 'package:kobo/core/shared/widget/page_background.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/features/about/bloc/git_hub_updater_cubit.dart';
import 'package:kobo/features/about/widget/new_version_widget.dart';
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
        actions: [
          BlocConsumer<GitHubUpdaterCubit, GitHubUpdaterState>(
            listener: (context, state) {
              if (state is Latest) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(context.tr('upToDate'))));
              }
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading:
                    () => IconButton(
                      onPressed: () {},
                      icon: const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                orElse:
                    () => IconButton(
                      onPressed:
                          () =>
                              context
                                  .read<GitHubUpdaterCubit>()
                                  .checkForUpdate(),
                      icon: const Icon(Icons.refresh),
                    ),
              );
            },
          ),
          const SizedBox(width: 4.0),
        ],
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
                  const SizedBox(height: 24),

                  Container(
                    width: context.widthPct(.9),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: context.colors.onInverseSurface,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.shadow.withAlpha(10),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: BlocBuilder<GitHubUpdaterCubit, GitHubUpdaterState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          success:
                              (gethubRelease) =>
                                  NewVersionWidget(newRelease: gethubRelease),
                          loading:
                              () => Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 16.0,
                                  children: [
                                    Text(context.tr("checkingUpdate")),
                                    const LinearProgressIndicator(),
                                  ],
                                ),
                              ),
                          latest:
                              () => Center(child: Text(context.tr("upToDate"))),
                          error:
                              (msg) => Center(
                                child: Text(
                                  context.tr(msg ?? "errorGeneral"),
                                  style: TextStyle(color: context.colors.error),
                                ),
                              ),
                          orElse: () => const SizedBox.shrink(),
                        );
                      },
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
