import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/widget/label_widget.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

class FormUsersScreen extends StatelessWidget {
  final KoboForm kForm;
  const FormUsersScreen({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String currentUserName = getIt<KoboService>().user.username;
    Map<String, List<Permission>> groupByUser(List<Permission> perms) {
      final Map<String, List<Permission>> grouped = {};
      for (var p in perms) {
        grouped.putIfAbsent(p.user, () => []).add(p);
      }
      return grouped;
    }

    final grouped = groupByUser(kForm.permissions);
    final users = grouped.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          subtitle: Text(kForm.name, overflow: TextOverflow.ellipsis),
          contentPadding: EdgeInsets.zero,
          title: Text(context.tr('users'), overflow: TextOverflow.ellipsis),
        ),
      ),
      body: ListView.separated(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final perms = grouped[user]!;
          List<String> userData = user.split('/');
          String userName = userData[userData.length - 2];
          bool isLoggedInUser = userName == currentUserName;
          return SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  trailing:
                      isLoggedInUser
                          ? LabelWidget(
                            title: context.tr('you'),
                            backgroundColor: theme.colorScheme.onPrimary,
                          )
                          : null,
                  leading:
                      userName == kForm.ownerUsername
                          ? Icon(
                            Icons.manage_accounts_outlined,
                            color: theme.colorScheme.error,
                          )
                          : Icon(
                            Icons.person_outline,
                            color: theme.colorScheme.primary,
                          ),
                  title: Text(userName),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 4.0,
                    children:
                        perms.map((p) {
                          return LabelWidget(title: p.label);
                        }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder:
            (BuildContext context, int index) => const SizedBox(height: 12.0),
      ),
    );
  }
}
