import 'package:flutter/widgets.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}


extension WidgetTapScale on Widget {
  Widget tapScale({
    Function()? onTap,
    Duration duration = const Duration(milliseconds: 500),
    double scaleFactor = 0.95,
  }) {
    return _TapScaleWidget(
      onTap: onTap,
      duration: duration,
      scaleFactor: scaleFactor,
      child: this,
    );
  }
}

class _TapScaleWidget extends StatefulWidget {
  final Widget child;
  final Function()? onTap;
  final Duration duration;
  final double scaleFactor;

  const _TapScaleWidget({
    required this.child,
    this.onTap,
    required this.duration,
    required this.scaleFactor,
  });

  @override
  State<_TapScaleWidget> createState() => _TapScaleWidgetState();
}

class _TapScaleWidgetState extends State<_TapScaleWidget> {
  double _scale = 1.0;

  void _animateScale(double scale) {
    setState(() {
      _scale = scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _animateScale(widget.scaleFactor),
      onTapUp: (_) => _animateScale(1.0),
      onTapCancel: () => _animateScale(1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: widget.duration,
        curve: Curves.easeOutCirc,
        child: widget.child,
      ),
    );
  }
}
