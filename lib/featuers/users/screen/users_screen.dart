import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/featuers/users/bloc/cubit/users_cubit.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    getUsersList(List<String> data, {String? loadingUser}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr("users"),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await BlocProvider.of<UsersCubit>(
                      context,
                    ).clearSavedUsers();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.pushNamedAndRemoveUntil(
                        Routes.loginScreen,
                        predicate: (Route<dynamic> route) => false,
                      );
                    });
                  },
                  label: Text(context.tr('clearAll')),
                  icon: Icon(Icons.close),
                  style: TextButton.styleFrom(
                    iconColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
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
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushNamedAndRemoveUntil(
                Routes.loginScreen,
                predicate: (Route<dynamic> route) => false,
              );
            });
          }
        },

        builder: (BuildContext context, UsersState state) {
          return state.when(
            loading: (msg) => Center(child: CircularProgressIndicator()),

            savedUsers: (data) => getUsersList(data),

            empty: () => Center(child: Text(context.tr("noSavedUsers"))),
            logging:
                (data, userName) => getUsersList(data, loadingUser: userName),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: context.tr("addAccount"),
        onPressed:
            () => context.pushNamedAndRemoveUntil(
              Routes.loginScreen,
              predicate: (Route<dynamic> route) => false,
            ),
        child: Icon(Icons.person_add),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String user;
  final String? loadingUser;
  const UserCard({super.key, required this.user, this.loadingUser});

  @override
  Widget build(BuildContext context) {
    bool isUserLoading = loadingUser != null && (user == loadingUser);

    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap:
          loadingUser != null
              ? null
              : () async {
                bool isAuth = await BlocProvider.of<UsersCubit>(
                  context,
                ).savedUserLogin(userName: user);
                if (isAuth) {
                  debugPrint("isAuth : $isAuth | $isUserLoading");
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.pushNamedAndRemoveUntil(
                      Routes.homeScreen,
                      predicate: (Route<dynamic> route) => false,
                    );
                  });
                }
              },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color:
              isUserLoading
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.surfaceContainer, // surfaceContainerLow
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          spacing: 12.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person),
            Expanded(
              child: Text(
                user,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isUserLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeCap: StrokeCap.round),
                )
                : Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
