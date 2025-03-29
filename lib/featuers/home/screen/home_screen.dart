import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions.dart';
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

  void logout({String? routeName}) {
    DioFactory.removeCredentialsIntoHeader();
    context.pushNamedAndRemoveUntil(
      routeName ?? Routes.loginScreen,
      predicate: (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    KoboUser koboUser = getIt<KoboService>().user;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: Text(
                        koboUser.username[0].toUpperCase(),
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                    const Spacer(flex: 2),
                    Text(
                      koboUser.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      koboUser.email,
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),

            Spacer(),
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
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder:
                      (BuildContext context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              Text(
                                context.tr("logout"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(context.tr('areYouSure')),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton.icon(
                                    onPressed: context.pop,
                                    label: Text(context.tr('cancel')),
                                    icon: Icon(Icons.close),
                                  ),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      iconColor: theme.colorScheme.error,
                                      foregroundColor: theme.colorScheme.error,
                                    ),
                                    onPressed: logout, // remove saved data from shared preferences
                                    label: Text(context.tr("logout")),
                                    icon: Icon(Icons.logout),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Kobo App'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(Routes.settingsScreen),
            icon: Icon(Icons.settings_outlined),
          ),
          SizedBox(width: 10),

          IconButton(onPressed: reFetchForms, icon: Icon(Icons.refresh)),
          SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<KoboformsCubit, KoboformsState>(
        builder: (context, state) {
          return state.when(
            initial:
                () => Center(
                  child: Column(
                    children: [
                      Text('Hello World!'),
                      FilledButton(
                        onPressed:
                            () =>
                                BlocProvider.of<KoboformsCubit>(
                                  context,
                                ).fetchForms(),
                        child: Text("getData"),
                      ),
                    ],
                  ),
                ),
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
              // if (screenSize.width < 600) {
              //   return RefreshIndicator(
              //     onRefresh: reFetchForms,
              //     child: ListView.builder(
              //       itemCount: data.length,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 8.0,
              //             vertical: 4.0,
              //           ),
              //           child: KoboFormCard(kForm: data[index]),
              //         );
              //       },
              //     ),
              //   );
              // }

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
      // bottomNavigationBar: NavigationBar(
      //   labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      //   destinations: [
      //     NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      //     NavigationDestination(
      //       icon: Icon(Icons.settings_outlined),
      //       label: 'Settings',
      //     ),
      //         NavigationDestination(
      //       icon: Icon(Icons.person_outline),
      //       label: 'Account',
      //     ),
      //   ],
      // ),
    );
  }
}
