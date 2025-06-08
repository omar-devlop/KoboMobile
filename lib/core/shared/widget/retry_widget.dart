import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kobo/core/helpers/extensions.dart';

class RetryWidget extends StatelessWidget {
  final String errorMsg;
  final Function()? onTap;
  const RetryWidget({super.key, required this.errorMsg, this.onTap});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      height: screenSize.height / 2,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: theme.colorScheme.onInverseSurface),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/404_Error.svg',
              width: screenSize.width / 1.5,
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                errorMsg,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    ).tapScale(onTap: onTap);
  }
}
