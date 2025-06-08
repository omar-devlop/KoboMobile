import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

double randomBetween(int min, int max) {
  final random = Random();
  return (min + random.nextInt(max - min + 1)).toDouble();
}

double mapValue(
  double value, {
  double? inputMin,
  double? inputMax,
  required double outputMin,
  required double outputMax,
}) {
  double actualInputMin = inputMin ?? 0.0;
  double actualInputMax = inputMax ?? 1.0;
  double t = (value - actualInputMin) / (actualInputMax - actualInputMin);
  return lerpDouble(outputMin, outputMax, t)!;
}

String getFormattedTimeAgo(
  BuildContext context,
  String dateTime, {
  String? pattern,
}) {
  final parsedDate = DateTime.tryParse(dateTime);
  if (parsedDate == null) {
    debugPrint('Invalid date: $dateTime');
    return dateTime;
  }

  final locale = context.locale.toString();
  return GetTimeAgo.parse(
    parsedDate.toLocal(),
    locale: locale,
    pattern: pattern,
  );
}

String getFormattedDate(
  BuildContext context,
  String dateTime, {
  String pattern = 'dd MMM yyyy, hh:mm a',
}) {
  final parsedDate = DateTime.tryParse(dateTime);
  if (parsedDate == null) {
    debugPrint('Invalid date: $dateTime');
    return dateTime;
  }

  final locale = context.locale.toString();
  final formatter = DateFormat(pattern, locale);

  return formatter.format(parsedDate.toLocal());
}

String getFormattedTime(
  BuildContext context,
  String timeOnly, {
  String pattern = 'hh:mm a',
}) {
  // Add today's date to the time string
  final today = DateTime.now().toIso8601String().split('T').first;
  final dateTimeString = '${today}T$timeOnly';

  final parsedDate = DateTime.tryParse(dateTimeString);
  if (parsedDate == null) {
    debugPrint('Invalid time: $timeOnly');
    return timeOnly;
  }

  final locale = context.locale.toString();
  final formatter = DateFormat(pattern, locale);

  return formatter.format(parsedDate.toLocal());
}

Color getRndColor(int index) {
  const fluentColors = [
    Color(0xFF0078D4),
    Color(0xFF107C10),
    Color(0xFFFFB900),
    Color(0xFFD83B01),
    Color(0xFF5C2D91),
    Color(0xFFE3008C),
    Color(0xFF00B294),
    Color(0xFFB4009E),
  ];
  if (index >= fluentColors.length) {
    final random = Random(index);
    return Color.fromARGB(
      225,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  return fluentColors[index % fluentColors.length].withAlpha(225);
}
