import 'dart:math';
import 'package:flutter/material.dart';

class FlippingCircle extends StatefulWidget {
  /// whether this tile is selected
  final bool selected;

  /// the 0-based index of this tile
  final int index;

  /// true if any selection is active (so we switch between number vs. empty)
  final bool multiSelectActive;

  const FlippingCircle({
    super.key,
    required this.selected,
    required this.index,
    required this.multiSelectActive,
  });

  @override
  State<FlippingCircle> createState() => _FlippingCircleState();
}

class _FlippingCircleState extends State<FlippingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (widget.selected) {
      _ctrl.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant FlippingCircle old) {
    super.didUpdateWidget(old);
    if (widget.selected != old.selected) {
      if (widget.selected) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final angle = _ctrl.value * pi;
        final isBack = _ctrl.value > 0.5;

        Widget rawContent =
            isBack
                ? Icon(Icons.done, color: theme.colorScheme.primary)
                : Text(
                  '${widget.index + 1}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFeatures: [const FontFeature.tabularFigures()],
                    color: theme.colorScheme.secondary,
                  ),
                );

        // عكس المحتوى إذا كنا على الوجه الخلفي حتى ما يطلع مقلوب
        final content = Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(isBack ? pi : 0),
          child: rawContent,
        );

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(angle),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isBack
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.onInverseSurface,
              border: Border.all(
                color:
                    isBack
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.onInverseSurface,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: content,
          ),
        );
      },
    );
  }
}
