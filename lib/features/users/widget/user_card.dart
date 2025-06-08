import 'package:flutter/material.dart';
import 'package:kobo/features/users/model/account.dart';

class UserCard extends StatelessWidget {
  final Account account;
  final String? loadingAccount;
  final String? failedLoginUser;
  const UserCard({
    super.key,
    required this.account,
    this.loadingAccount,
    this.failedLoginUser,
  });

  @override
  Widget build(BuildContext context) {
    bool isUserLoading =
        loadingAccount != null && (account.username == loadingAccount);
    bool isFailedLogin =
        failedLoginUser != null && (account.username == failedLoginUser);
    // isUserLoading = true; // delete
    ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),

      decoration: BoxDecoration(
        color:
            isFailedLogin
                ? theme.colorScheme.errorContainer
                : isUserLoading
                ? theme.colorScheme.secondaryContainer
                : theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        spacing: 12.0,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.person),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.username,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  account.serverUrl,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          isUserLoading
              ? const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 8.0),
                ],
              )
              : const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
