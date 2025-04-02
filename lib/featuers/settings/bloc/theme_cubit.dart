import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void cycleTheme() {
    final nextIndex = (state.index + 1) % ThemeMode.values.length;
    emit(ThemeMode.values[nextIndex]);
  }

  void setTheme(ThemeMode theme) => emit(theme);

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    final themeIndex = json['themeMode'] as int?;
    if (themeIndex == null ||
        themeIndex < 0 ||
        themeIndex >= ThemeMode.values.length) {
      return ThemeMode.system;
    }
    return ThemeMode.values[themeIndex];
  }

  @override
  Map<String, dynamic> toJson(ThemeMode state) {
    return {'themeMode': state.index};
  }
}
