import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AccentColorCubit extends HydratedCubit<Color> {
  AccentColorCubit() : super(Colors.blue);

  void setColor(Color color) => emit(color);

  @override
  Color fromJson(Map<String, dynamic> json) {
    final colorValue = json['color'] as int?;
    if (colorValue == null) return Colors.blue;
    return Color(colorValue);
  }

  @override
  Map<String, dynamic> toJson(Color state) {
    return {'color': state.toARGB32()};
  }
}
