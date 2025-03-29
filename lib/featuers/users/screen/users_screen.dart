import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/featuers/users/bloc/cubit/users_cubit.dart';
import 'package:kobo/featuers/users/widget/user_card.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;

    navigateToLoginScreen() {
      if (context.mounted) {
        context.pushNamedAndRemoveUntil(
          Routes.loginScreen,
          predicate: (Route<dynamic> route) => false,
        );
      }
    }

    clearAllSavedAccounts() async {
      await BlocProvider.of<UsersCubit>(context).clearSavedUsers();
      navigateToLoginScreen();
    }

    getUsersList(List<String> data, {String? loadingUser}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            SizedBox(height: 72),
            SvgPicture.asset(
              'assets/svg/kobo_logo.svg',
              width: screenSize.width / 1.5,
            ),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr("savedAccounts"),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
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
                                    context.tr("clearAll"),
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
                                          foregroundColor:
                                              theme.colorScheme.error,
                                        ),
                                        onPressed: clearAllSavedAccounts,
                                        label: Text(context.tr("clearAll")),
                                        icon: Icon(Icons.delete_outline),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                    );
                  },
                  label: Text(context.tr('clearAll')),
                  icon: Icon(Icons.delete_outline),
                  style: TextButton.styleFrom(
                    iconColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index == data.length) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(),
                        ),
                        GestureDetector(
                          onTap: navigateToLoginScreen,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              spacing: 12.0,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: theme.colorScheme.primary,
                                ),
                                Expanded(
                                  child: Text(
                                    context.tr("addAccount"),
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelLarge!.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.add,
                                  color: theme.colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return UserCard(user: data[index], loadingUser: loadingUser);
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextButton.icon(
          icon: Icon(Icons.language),
          label: Text(context.tr(context.locale.languageCode)),
          onPressed: () => context.pushNamed(Routes.languagesScreen),
        ),
      ),
      body: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {
          if (state is Empty) {
            navigateToLoginScreen();
          }
        },

        builder: (BuildContext context, UsersState state) {
          return state.when(
            loading: (msg) => Center(child: CircularProgressIndicator()),

            savedUsers: (data) => getUsersList(data),

            empty: () => getUsersList([]),
            logging:
                (data, userName) => getUsersList(data, loadingUser: userName),
          );
        },
      ),
    );
  }
}
