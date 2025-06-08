import 'package:flutter/material.dart';

class SettingsTileWidget extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final Icon? leading;
  final Icon? trailing;
  final Color? iconColor;
  final Color? textColor;
  final Color? containerColor;

  const SettingsTileWidget({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.trailing,
    this.iconColor,
    this.textColor,
    this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: containerColor ?? theme.colorScheme.onInverseSurface,
      ),
      child: ListTile(
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor ?? theme.colorScheme.inverseSurface,
          ),
        ),
        leading: leading,
        iconColor: iconColor ?? theme.colorScheme.primary,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
