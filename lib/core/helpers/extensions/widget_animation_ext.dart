import 'package:flutter/material.dart';
import 'package:kobo/core/shared/widget/tap_scale_widget.dart';

extension WidgetTapScale on Widget {
  Widget tapScale({
    Function()? onTap,
    Duration duration = const Duration(milliseconds: 500),
    double scaleFactor = 0.95,
    bool enabled = true,
  }) {
    if (!enabled) return this;
    return TapScaleWidget(
      onTap: onTap,
      duration: duration,
      scaleFactor: scaleFactor,
      child: this,
    );
  }
}
