import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobo/features/settings/bloc/accent_color_cubit.dart';

ThemeData lightTheme(BuildContext context, ColorScheme? lightDynamic) {
  final seedColor = context.read<AccentColorCubit>().state;
  final scheme =
      (seedColor == Colors.white && lightDynamic != null)
          ? lightDynamic
          : ColorScheme.fromSeed(seedColor: seedColor);

  return ThemeData.light().copyWith(
    textTheme: GoogleFonts.cairoTextTheme(),
    colorScheme: scheme,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeCap: StrokeCap.round,
      color: scheme.primary,
    ),
    dividerColor: Colors.transparent,
  );
}

ThemeData darkTheme(BuildContext context, ColorScheme? darkDynamic) {
  final seedColor = context.read<AccentColorCubit>().state;
  final ColorScheme scheme =
      (seedColor == Colors.white && darkDynamic != null)
          ? darkDynamic
          : ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: seedColor,
          );

  return ThemeData.dark().copyWith(
    textTheme: GoogleFonts.cairoTextTheme(),
    colorScheme: scheme,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeCap: StrokeCap.round,
      color: scheme.primary,
    ),
    dividerColor: Colors.transparent,
  );
}
