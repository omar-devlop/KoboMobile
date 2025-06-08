import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/features/content/model/tree_node.dart';
import 'package:intl/intl.dart' show Bidi;

/// Widget that renders a [QuestionNode] and, if tapped, expands/collapses its children.
class TreeNodeWidget extends StatefulWidget {
  final QuestionNode node;
  final int depth;

  const TreeNodeWidget({super.key, required this.node, required this.depth});

  @override
  State<TreeNodeWidget> createState() => __TreeNodeWidgetState();
}

class __TreeNodeWidgetState extends State<TreeNodeWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final hasChildren = widget.node.children.isNotEmpty;
    bool isRtlTitle = Bidi.detectRtlDirectionality(widget.node.title);
    TextDirection titleDir = isRtlTitle ? TextDirection.rtl : TextDirection.ltr;
    return AnimatedContainer(
      margin: EdgeInsets.only(left: widget.depth > 0 ? 16.0 : 0.0, bottom: 8),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(4.0),
        border:
            _isExpanded
                ? Border.all(color: theme.colorScheme.outlineVariant)
                : Border.all(color: theme.colorScheme.onInverseSurface),
        boxShadow: [
          if (_isExpanded)
            const BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.node.question.getIcon(), size: 15),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            title: SelectableText.rich(
              textDirection: titleDir,
              TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: widget.node.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: hasChildren ? FontWeight.bold : null,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  if (widget.node.question.isRequired)
                    TextSpan(
                      text: ' *',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),

            trailing:
                hasChildren
                    ? RotationTransition(
                      turns: _iconTurns,
                      child: const Icon(Icons.expand_more),
                    )
                    : null,
            onTap: hasChildren ? _handleTap : null,
          ),

          // AnimatedSize wraps the children to animate height changes
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              // When collapsed, force zero height
              constraints:
                  _isExpanded
                      ? const BoxConstraints()
                      : const BoxConstraints(maxHeight: 0.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  children:
                      widget.node.children
                          .map(
                            (child) => TreeNodeWidget(
                              node: child,
                              depth: widget.depth + 1,
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
