import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kobo/core/helpers/extensions/build_context_ext.dart';
import 'package:kobo/core/shared/models/in_app_message.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/features/notifications/bloc/notifications_cubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('notifications'),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (_, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            success:
                (inAppMessagesList) =>
                    inAppMessagesList.isEmpty
                        ? Center(
                          child: Text(
                            context.tr('noNotifications'),
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: inAppMessagesList.length,
                          itemBuilder: (context, index) {
                            AppMessage appMessage = inAppMessagesList[index];
                            return ListTile(
                              title: Text(appMessage.title),
                              subtitle: HtmlWidget(appMessage.html.snippet),
                              onTap:
                                  () => context.pushNamed(
                                    Routes.notificationDetailsScreen,
                                    arguments: [inAppMessagesList, index],
                                  ),
                            );
                          },
                        ),
          );
        },
      ),
    );
  }
}
