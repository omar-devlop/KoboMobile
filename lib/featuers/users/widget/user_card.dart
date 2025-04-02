import 'package:flutter/material.dart';
import 'package:kobo/featuers/users/model/account.dart';

class UserCard extends StatelessWidget {
  final Account account;
  final String? loadingAccount;
  const UserCard({super.key, required this.account, this.loadingAccount});

  @override
  Widget build(BuildContext context) {
    bool isUserLoading =
        loadingAccount != null && (account.username == loadingAccount);
    // isUserLoading = true; // delete
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),

      decoration: BoxDecoration(
        color:
            isUserLoading
                ? theme.colorScheme.secondaryContainer
                : theme.colorScheme.surfaceContainer,
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
              ? Row(
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
              : Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
