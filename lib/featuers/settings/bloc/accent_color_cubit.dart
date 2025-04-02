import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AccentColorCubit extends HydratedCubit<Color> {
  AccentColorCubit() : super(Colors.white);

  void setColor(Color color) => emit(color);

  @override
  Color fromJson(Map<String, dynamic> json) {
    final colorValue = json['color'] as int?;
    if (colorValue == null) return Colors.white;
    return Color(colorValue);
  }

  @override
  Map<String, dynamic> toJson(Color state) {
    return {'color': state.toARGB32()};
  }
}
