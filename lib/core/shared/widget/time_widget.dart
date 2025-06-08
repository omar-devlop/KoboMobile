import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions/widget_animation_ext.dart';

class TimeWidget extends StatelessWidget {
  final String content;
  const TimeWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height / 10,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(width: .5, color: theme.colorScheme.secondary),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.timer,
            size: 54.0,
            color: theme.colorScheme.onSecondary.withAlpha(25),
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    ).tapScale();
  }
}
