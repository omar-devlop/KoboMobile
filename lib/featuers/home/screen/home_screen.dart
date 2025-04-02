import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/confirm_dialog.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/helpers/preferences_service.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/utils/networking/dio_factory';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_user.dart';
import 'package:kobo/data/services/kobo_service.dart';
import 'package:kobo/featuers/home/bloc/kobo_forms_cubit.dart';
import 'package:kobo/featuers/home/widget/kobo_form_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> reFetchForms() async =>
      BlocProvider.of<KoboformsCubit>(context).fetchForms();

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
    Size screenSize = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      drawer: Drawer(
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
                        // const Spacer(flex: 2),
                        Text(
                          koboUser.username,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          koboUser.extraDetails.name,
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(koboUser.email, style: theme.textTheme.bodyMedium),
                        // const Spacer(flex: 1),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(context.tr('settings')),
              onTap: () => context.pushNamed(Routes.settingsScreen),
            ),
            ListTile(
              iconColor: theme.colorScheme.error,
              textColor: theme.colorScheme.error,
              leading: Icon(Icons.delete_forever_outlined),
              title: Text(context.tr('clearSavedPreferences')),
              onTap:
                  () => showConfirmationDialog(
                    context: context,
                    onConfirm: PreferencesService.clearAllSavedPreferences,
                    title: context.tr("clearSavedPreferences"),
                  ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.group_outlined),
              title: Text(context.tr('changeAccounts')),
              onTap: () => logout(routeName: Routes.usersScreen),
            ),
            ListTile(
              iconColor: theme.colorScheme.error,
              textColor: theme.colorScheme.error,
              leading: Icon(Icons.logout),
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
            SizedBox(height: 20),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Hi, ${koboUser.extraDetails.name}'),
        actions: [
          IconButton(onPressed: reFetchForms, icon: Icon(Icons.refresh)),
          SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<KoboformsCubit, KoboformsState>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(child: CircularProgressIndicator()),
            loading:
                (msg) => Center(
                  child: Column(
                    spacing: 20.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      if (msg != null) Text(msg),
                    ],
                  ),
                ),
            success: (data) {
              return RefreshIndicator(
                onRefresh: reFetchForms,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        screenSize.width < 600
                            ? 1
                            : (screenSize.width / 300).toInt(),
                    childAspectRatio:
                        screenSize.width < 600 ? screenSize.width / 110 : 2.5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return KoboFormCard(kForm: data[index]);
                  },
                ),
              );
            },
            error: (error) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}
