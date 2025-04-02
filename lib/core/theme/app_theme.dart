import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/featuers/settings/bloc/accent_color_cubit.dart';

ThemeData lightTheme(BuildContext context, ColorScheme? lightDynamic) {
  Color color = context.read<AccentColorCubit>().state;
  return ThemeData.light().copyWith(
    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeCap: StrokeCap.round,
    ),
    colorScheme:
        (color == Colors.white && lightDynamic != null)
            ? lightDynamic
            : ColorScheme.fromSeed(
              seedColor: context.read<AccentColorCubit>().state,
            ),
    dividerColor: Colors.transparent,
  );
}

ThemeData darkTheme(BuildContext context, ColorScheme? darkDynamic) {
  Color color = context.read<AccentColorCubit>().state;

  return ThemeData.dark().copyWith(
    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeCap: StrokeCap.round,
    ),
    colorScheme:
        (color == Colors.white && darkDynamic != null)
            ? darkDynamic
            : ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: context.read<AccentColorCubit>().state,
            ),

    dividerColor: Colors.transparent,
  );
}
