import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show Bidi;

class FieldContainer extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String? xmlValue;
  final String? data;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const FieldContainer({
    super.key,
    required this.title,
    this.titleStyle,
    this.xmlValue,
    this.data,
    this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isRtlTitle = Bidi.detectRtlDirectionality(title);
    TextDirection titleDir = isRtlTitle ? TextDirection.rtl : TextDirection.ltr;
    bool isRtlData = data != null ? Bidi.detectRtlDirectionality(data!) : false;
    TextDirection dataDir = isRtlData ? TextDirection.rtl : TextDirection.ltr;

    return Padding(
      padding: padding ?? const EdgeInsets.all(12.0),
      child: SelectionArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 2.0,
          children: [
            Padding(
              padding:
                  padding != null
                      ? const EdgeInsets.only(
                        left: 12.0,
                        right: 12.0,
                        top: 12.0,
                      )
                      : EdgeInsets.zero,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style:
                          titleStyle ??
                          theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                    ),
                    const WidgetSpan(child: SizedBox(width: 6.0)),
                    if (xmlValue != null)
                      TextSpan(
                        text: xmlValue,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                  ],
                ),
                textDirection: titleDir,
              ),
            ),
            if (child != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: child!,
              ),
            if (data != null)
              Text(
                data!,
                textDirection: dataDir,
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
          ],
        ),
      ),
    );
  }
}
