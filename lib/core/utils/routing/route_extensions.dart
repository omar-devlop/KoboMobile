import 'package:flutter/material.dart';

/// Extension on Widget to produce a transitions Route.
extension RouteExtension on Widget {
  PageRoute<T> slideRoute<T>({Offset beginOffset = const Offset(0, 1)}) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => this,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: beginOffset,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  PageRoute<T> scaleRoute<T>({
    double beginScale = 0.8,
    Curve curve = Curves.easeOutBack,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => this,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: beginScale,
          end: 1.0,
        ).chain(CurveTween(curve: curve));
        return ScaleTransition(scale: animation.drive(tween), child: child);
      },
    );
  }

  PageRoute<T> fadeRoute<T>({
    double beginOpacity = 0.0,
    Curve curve = Curves.easeInOutCubic,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => this,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: beginOpacity,
          end: 1.0,
        ).chain(CurveTween(curve: curve));
        return FadeTransition(opacity: animation.drive(tween), child: child);
      },
    );
  }

  PageRoute<T> scaleFadeRoute<T>({
    double beginScale = 0.8,
    double beginOpacity = 0.0,
    Curve scaleCurve = Curves.easeInOutCubic,
    Curve fadeCurve = Curves.easeInOutCubic,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => this,
      transitionsBuilder: (_, animation, __, child) {
        // Separate tweens for scale and fade
        final scaleTween = Tween(
          begin: beginScale,
          end: 1.0,
        ).chain(CurveTween(curve: scaleCurve));
        final fadeTween = Tween(
          begin: beginOpacity,
          end: 1.0,
        ).chain(CurveTween(curve: fadeCurve));

        // Drive the same animation for both
        final scaleAnim = animation.drive(scaleTween);
        final fadeAnim = animation.drive(fadeTween);

        // Nest them: first scale, then fade
        return ScaleTransition(
          scale: scaleAnim,
          child: FadeTransition(opacity: fadeAnim, child: child),
        );
      },
    );
  }
}
