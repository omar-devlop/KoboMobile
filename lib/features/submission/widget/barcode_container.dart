import 'package:barcode_widget/barcode_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BarcodeContainer extends StatefulWidget {
  final String title;
  final String data;
  const BarcodeContainer({super.key, required this.title, required this.data});

  @override
  State<BarcodeContainer> createState() => _BarcodeContainerState();
}

class _BarcodeContainerState extends State<BarcodeContainer> {
  bool showQrCode = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          visualDensity: VisualDensity.compact,
          controlAffinity: ListTileControlAffinity.leading,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(context.tr('showQr'), overflow: TextOverflow.ellipsis),
              const Icon(Icons.qr_code),
            ],
          ),

          value: showQrCode,
          onChanged: (value) {
            if (!mounted) return;
            setState(() {
              showQrCode = value ?? false;
            });
          },
        ),

        if (showQrCode)
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withAlpha(25),
                  blurRadius: 4,
                ),
              ],
            ),
            child: BarcodeWidget(barcode: Barcode.qrCode(), data: widget.data),
          ),
      ],
    );
  }
}
