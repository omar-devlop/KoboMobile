import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kobo/core/helpers/help_func.dart';

class ShadedFormsList extends StatelessWidget {
  const ShadedFormsList({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color greyColor = Colors.grey.shade300;
    return ListView.separated(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 8.0);
          },
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 4.0,
                left: 12,
                right: 12,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: randomBetween(25, 100),
                        height: 15,
                        decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        width: randomBetween(25, 75),
                        height: 15,
                        decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right, color: greyColor),
                    ],
                  ),
                  Container(
                    width: randomBetween(50, 75),
                    height: 25,
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...List<Container>.generate(
                        randomBetween(1, 4).toInt(),
                        (i) => Container(
                          margin: const EdgeInsets.only(right: 6.0),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: greyColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: null,
                        disabledColor: greyColor,
                        icon: const Icon(Icons.question_answer_outlined),
                      ),
                      IconButton(
                        disabledColor: greyColor,
                        onPressed: null,
                        icon: const Icon(Icons.data_array),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        )
        .animate(onComplete: (controller) => controller.repeat())
        .shimmer(duration: const Duration(seconds: 1));
  }
}
