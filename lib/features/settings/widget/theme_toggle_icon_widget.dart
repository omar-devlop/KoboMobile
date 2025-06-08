import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/features/settings/bloc/theme_cubit.dart';

class ThemeToggleIconWidget extends StatelessWidget {
  const ThemeToggleIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<ThemeCubit>().cycleTheme(),
      icon: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return Icon(
            themeMode == ThemeMode.light
                ? Icons.light_mode
                : themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.brightness_auto,
            color: Theme.of(context).colorScheme.primary,
          );
        },
      ),
    );
  }
}
