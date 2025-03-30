import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/featuers/users/bloc/cubit/users_cubit.dart';

class UserCard extends StatelessWidget {
  final String user;
  final String? loadingUser;
  const UserCard({super.key, required this.user, this.loadingUser});

  @override
  Widget build(BuildContext context) {
    bool isUserLoading = loadingUser != null && (user == loadingUser);
    // isUserLoading = true; // delete
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

                  if (context.mounted) {
                    context.pushNamedAndRemoveUntil(
                      Routes.homeScreen,
                      predicate: (Route<dynamic> route) => false,
                    );
                  }
                }
              },
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),

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
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    SizedBox(width: 8.0),
                  ],
                )
                : Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
