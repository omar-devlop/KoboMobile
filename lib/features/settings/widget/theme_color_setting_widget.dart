import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/features/settings/bloc/accent_color_cubit.dart';

class ThemeColorSettingWidget extends StatelessWidget {
  const ThemeColorSettingWidget({super.key});

  static const List<Color> firstRowColors = [
    Colors.white,
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    Colors.green,
  ];

  static const List<Color> secondRowColors = [
    Colors.yellow,
    Colors.orange,
    Colors.deepOrange,
    Colors.pink,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AccentColorCubit, Color>(
      builder: (context, selectedThemeColor) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: theme.colorScheme.onInverseSurface,
          ),
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(vertical: 16),
            leading: Icon(Icons.color_lens, color: theme.colorScheme.primary),
            collapsedIconColor: theme.colorScheme.primary,
            initiallyExpanded: true,
            shape: const Border(),
            title: Text(
              context.tr('accentColor'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.inverseSurface,
              ),
            ),
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        firstRowColors.map((color) {
                          return IconButton(
                            onPressed:
                                () => context.read<AccentColorCubit>().setColor(
                                  color,
                                ),
                            icon: Icon(
                              selectedThemeColor.toARGB32() == color.toARGB32()
                                  ? (color == Colors.white)
                                      ? Icons.hdr_auto
                                      : Icons.radio_button_checked
                                  : (color == Colors.white)
                                  ? Icons.hdr_auto_outlined
                                  : Icons.radio_button_off,
                            ),
                            color:
                                (color == Colors.white)
                                    ? theme.colorScheme.primary
                                    : color,
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        secondRowColors.map((color) {
                          return IconButton(
                            onPressed:
                                () => context.read<AccentColorCubit>().setColor(
                                  color,
                                ),
                            icon: Icon(
                              selectedThemeColor.toARGB32() == color.toARGB32()
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                            ),
                            color: color,
                          );
                        }).toList(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
