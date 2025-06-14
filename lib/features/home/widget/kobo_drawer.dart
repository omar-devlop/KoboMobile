import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions/build_context_ext.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/models/kobo_user.dart';
import 'package:kobo/core/shared/widget/confirm_dialog.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/networking/dio_factory.dart';
import 'package:kobo/core/utils/routing/routes.dart';

class KoboDrawer extends StatefulWidget {
  const KoboDrawer({super.key});

  @override
  State<KoboDrawer> createState() => _KoboDrawerState();
}

class _KoboDrawerState extends State<KoboDrawer> {
  late KoboService koboService;
  late KoboUser koboUser;

  void logout({String? routeName, bool removeSavedAccount = false}) {
    DioFactory.removeCredentialsIntoHeader();

    if (removeSavedAccount) {
      koboService.removeSavedAccount();
    }

    context.pushNamedAndRemoveUntil(
      routeName ?? Routes.loginScreen,
      predicate: (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    koboService = getIt<KoboService>();
    koboUser = koboService.user;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: Text(
                          koboUser.username[0].toUpperCase(),
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                      Text(
                        koboUser.username,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      Text(
                        koboUser.extraDetails.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      Text(
                        koboUser.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.manage_search_outlined),
            title: Text(context.tr('deepSearch')),
            onTap: () => context.pushNamed(Routes.deepSearchScreen),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(context.tr('settings')),
            onTap: () => context.pushNamed(Routes.settingsScreen),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.group_outlined),
            title: Text(context.tr('changeAccounts')),
            onTap: () => logout(routeName: Routes.usersScreen),
          ),
          ListTile(
            iconColor: theme.colorScheme.error,
            textColor: theme.colorScheme.error,
            leading: const Icon(Icons.logout),
            title: Text(context.tr('logout')),
            onTap:
                () => showConfirmationDialog(
                  context: context,
                  onConfirm: () => logout(removeSavedAccount: true),
                  confirmText: context.tr("logout"),
                  title: context.tr("logout"),
                  confirmIcon: Icons.logout,
                ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
