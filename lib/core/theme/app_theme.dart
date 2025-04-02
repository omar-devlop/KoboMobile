import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/featuers/settings/bloc/accent_color_cubit.dart';

ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
  progressIndicatorTheme: ProgressIndicatorThemeData(
    strokeCap: StrokeCap.round,
  ),
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: context.read<AccentColorCubit>().state,
  ),

  dividerColor: Colors.transparent,
);

ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
  progressIndicatorTheme: ProgressIndicatorThemeData(
    strokeCap: StrokeCap.round,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: context.read<AccentColorCubit>().state,
  ),
  dividerColor: Colors.transparent,
);
