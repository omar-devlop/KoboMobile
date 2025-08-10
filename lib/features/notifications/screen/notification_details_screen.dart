import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kobo/core/shared/models/in_app_message.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final List<AppMessage> inAppMessagesList;
  final int initialPage;

  const NotificationDetailsScreen({
    super.key,
    required this.inAppMessagesList,
    required this.initialPage,
  });

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  late PageController _pageController;
  int currPage = 1;
  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialPage);
    currPage = widget.initialPage + 1;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
        actions: [
          if (widget.inAppMessagesList.length > 1)
            Text(
              '$currPage / ${widget.inAppMessagesList.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          const SizedBox(width: 20),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.inAppMessagesList.length,
        onPageChanged: (value) {
          currPage = value.toInt() + 1;

          if (mounted) setState(() {});
        },
        itemBuilder: (context, index) {
          AppMessage appMessage = widget.inAppMessagesList[index];
          return ListView(
            padding: const EdgeInsets.all(14.0),
            children: [
              Text(appMessage.title, style: theme.textTheme.headlineSmall),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(),
              ),
              HtmlWidget(
                appMessage.html.body,
                onTapUrl: (url) async {
                  if (await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.platformDefault,
                  )) {
                    return true;
                  } else {
                    return false;
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
