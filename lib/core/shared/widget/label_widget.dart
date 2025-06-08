import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? forgroundColor;
  final Color? backgroundColor;
  final bool? showLabel;
  final TextStyle? textStyle;

  const LabelWidget({
    super.key,
    required this.title,
    this.icon,
    this.forgroundColor,
    this.backgroundColor,
    this.showLabel,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    bool isLabelVisible = showLabel ?? true;
    ThemeData theme = Theme.of(context);
    Color mForgroundColor = forgroundColor ?? theme.colorScheme.primary;
    Color mBackgroundColor =
        backgroundColor ?? theme.colorScheme.primaryContainer;

    return Container(
      height: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: mBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 10.0, color: mForgroundColor),
          if (icon != null && isLabelVisible) const SizedBox(width: 6.0),
          if (isLabelVisible)
            Text(
              title,
              style:
                  textStyle ??
                  theme.textTheme.labelSmall?.copyWith(color: mForgroundColor),
            ),
        ],
      ),
    );
  }
}
