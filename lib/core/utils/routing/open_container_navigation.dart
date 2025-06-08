import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class OpenContainerNavigation extends StatelessWidget {
  const OpenContainerNavigation({
    super.key,
    required this.openPage,
    required this.child,
    this.closedColor,
    this.borderRadius = 250,
    this.closedElevation,
    this.onClosed,
    this.onOpen,
  });

  final Widget openPage;
  final Widget Function(VoidCallback openContainer) child;
  final Color? closedColor;
  final double borderRadius;
  final double? closedElevation;
  final VoidCallback? onClosed;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      onClosed: (_) async {
        if (onClosed != null) onClosed!();
      },
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return openPage;
      },
      tappable: false,
      transitionDuration: const Duration(milliseconds: 400),
      closedElevation: closedElevation ?? 0,
      openColor: closedColor ?? Colors.transparent,
      closedColor: closedColor ?? Colors.transparent,
      openElevation: 0,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return child(() {
          if (onOpen != null) onOpen!();
          openContainer();
        });
      },
    );
  }
}
