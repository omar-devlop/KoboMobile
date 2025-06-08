import 'package:flutter/material.dart';

class PageBackground extends StatefulWidget {
  final Color? color;
  final bool filp;
  const PageBackground({super.key, this.color, this.filp = false});

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _heightFactor = Tween<double>(
      begin: 1,
      end: 3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color bgColor = widget.color ?? theme.colorScheme.primary;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size screenSize = mediaQuery.size;
    final appBarHeight = kToolbarHeight;

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Transform.translate(
            offset:
                widget.filp
                    ? const Offset(0, 0)
                    : Offset(0, -(appBarHeight * 2)),
            child: Transform.scale(
              scaleX: ((constraints.maxWidth * screenSize.aspectRatio) / 250)
                  .clamp(3, 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:
                    widget.filp
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: _heightFactor,
                    builder: (context, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: constraints.maxHeight / _heightFactor.value,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center:
                                widget.filp
                                    ? Alignment.bottomCenter
                                    : Alignment.topCenter,
                            colors: [
                              bgColor.withAlpha(150),
                              bgColor.withAlpha(0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
