import 'package:flutter/material.dart';

class TapScaleWidget extends StatefulWidget {
  final Widget child;
  final Function()? onTap;
  final Duration duration;
  final double scaleFactor;

  const TapScaleWidget({
    super.key,
    required this.child,
    this.onTap,
    required this.duration,
    required this.scaleFactor,
  });

  @override
  State<TapScaleWidget> createState() => _TapScaleWidgetState();
}

class _TapScaleWidgetState extends State<TapScaleWidget> {
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
