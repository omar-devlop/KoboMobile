import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/features/settings/bloc/theme_cubit.dart';

class ThemeModeSettingWidget extends StatelessWidget {
  const ThemeModeSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final List<Map<String, Object>> themeModes = [
      {
        'mode': ThemeMode.system,
        'icon': Icons.brightness_auto,
        'label': 'followSystem',
      },
      {'mode': ThemeMode.light, 'icon': Icons.light_mode, 'label': 'lightMode'},
      {'mode': ThemeMode.dark, 'icon': Icons.dark_mode, 'label': 'darkMode'},
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: theme.colorScheme.onInverseSurface,
      ),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(vertical: 16),
        leading: Icon(Icons.format_paint, color: theme.colorScheme.primary),
        collapsedIconColor: theme.colorScheme.primary,
        initiallyExpanded: true,
        shape: const Border(),

        title: Text(
          context.tr('appearance'),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.inverseSurface,
          ),
        ),

        children: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return Column(
                children:
                    themeModes.map((item) {
                      bool isSelected = themeMode == item['mode'];
                      return ListTile(
                        iconColor:
                            isSelected ? theme.colorScheme.primary : null,
                        textColor:
                            isSelected ? theme.colorScheme.primary : null,
                        onTap:
                            () => context.read<ThemeCubit>().setTheme(
                              item['mode'] as ThemeMode,
                            ),
                        trailing: isSelected ? const Icon(Icons.done) : null,
                        leading: Icon(item['icon'] as IconData),
                        title: Text(context.tr(item['label'] as String)),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
