import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kobo/core/shared/widget/page_background.dart';
import 'package:kobo/core/shared/widget/confirm_dialog.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/features/settings/widget/theme_toggle_icon_widget.dart';
import 'package:kobo/features/users/bloc/cubit/users_cubit.dart';
import 'package:kobo/features/users/model/account.dart';
import 'package:kobo/features/users/widget/user_card.dart';

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
      await BlocProvider.of<UsersCubit>(context).clearSavedAccounts();
      navigateToLoginScreen();
    }

    Widget getUsersList(
      List<Account> usersList, {
      String? loadingUser,
      String? failedLoginError,
      String? failedLoginUser,
    }) {
      return ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        buildDefaultDragHandles: false,
        itemCount: usersList.length,

        header: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12.0,
          children: [
            const SizedBox(height: 72),
            SvgPicture.asset(
              'assets/svg/kobo_logo.svg',
              width: screenSize.width / 1.5,
            ),
            const SizedBox(height: 48),

            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr("savedAccounts"),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                TextButton.icon(
                  onPressed:
                      () => showConfirmationDialog(
                        context: context,
                        title: context.tr('clearAll'),
                        confirmText: context.tr('clearAll'),
                        confirmIcon: Icons.delete_outline,
                        onConfirm: clearAllSavedAccounts,
                      ),

                  label: Text(context.tr('clearAll')),
                  icon: const Icon(Icons.delete_outline),
                  style: TextButton.styleFrom(
                    iconColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),

        proxyDecorator: (child, index, animation) {
          return Material(color: Colors.transparent, child: child);
        },
        itemBuilder: (context, index) {
          return ReorderableDelayedDragStartListener(
            index: index,
            key: Key(index.toString()),
            child: UserCard(
              account: usersList[index],
              loadingAccount: loadingUser,
              failedLoginUser: failedLoginUser,
            ).tapScale(
              onTap:
                  (loadingUser != null)
                      ? null
                      : () async {
                        bool isAuth = await BlocProvider.of<UsersCubit>(
                          context,
                        ).savedAccountLogin(usersList[index]);
                        if (isAuth) {
                          if (context.mounted) {
                            context.pushNamedAndRemoveUntil(
                              Routes.homeScreen,
                              predicate: (Route<dynamic> route) => false,
                            );
                          }
                        }
                      },
            ),
          );
        },

        onReorder: BlocProvider.of<UsersCubit>(context).onReorder,
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                spacing: 12.0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, color: theme.colorScheme.primary),
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
                  Icon(Icons.add, color: theme.colorScheme.primary),
                ],
              ),
            ).tapScale(onTap: navigateToLoginScreen),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.language),
              label: Text(context.tr(context.locale.languageCode)),
              onPressed: () => context.pushNamed(Routes.languagesScreen),
            ),
            const ThemeToggleIconWidget(),
          ],
        ),
      ),
      body: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {
          if (state is Empty) {
            navigateToLoginScreen();
          } else if (state is LoginError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error.toString())));
          }
        },

        builder: (BuildContext context, UsersState state) {
          return Stack(
            children: [
              state.maybeWhen(
                savedUsers:
                    (data, loggingUserName) => PageBackground(
                      color:
                          loggingUserName != null ? Colors.orangeAccent : null,
                    ),
                loading:
                    (msg) => const PageBackground(color: Colors.orangeAccent),
                loginError:
                    (data, loggingUserName, error) =>
                        PageBackground(color: theme.colorScheme.error),
                orElse: () => const PageBackground(),
              ),
              state.when(
                loading:
                    (msg) => const Center(child: CircularProgressIndicator()),

                savedUsers: (data, loggingUserName) {
                  return getUsersList(data, loadingUser: loggingUserName);
                },

                empty: () {
                  return getUsersList([]);
                },
                loginError: (
                  List<Account> data,
                  String? loggingUserName,
                  String error,
                ) {
                  return getUsersList(
                    data,
                    failedLoginUser: loggingUserName,
                    failedLoginError: error,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
