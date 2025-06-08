import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kobo/core/helpers/help_func.dart';

class ShadedDataList extends StatelessWidget {
  const ShadedDataList({super.key});

  @override
  Widget build(BuildContext context) {
    Color greyColor = Colors.grey.shade300;
    return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(backgroundColor: greyColor),
              title: Row(
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
                ],
              ),
              trailing: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            );
          },
        )
        .animate(onComplete: (controller) => controller.repeat())
        .shimmer(duration: const Duration(seconds: 1));
  }
}
