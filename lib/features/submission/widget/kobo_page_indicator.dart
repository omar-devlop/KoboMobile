import 'package:flutter/material.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class KoboPageIndicator extends StatelessWidget {
  const KoboPageIndicator({
    super.key,
    required this.pageController,
    required this.survey,
  });

  final PageController pageController;
  final KoboFormRepository survey;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
        child: SmoothPageIndicator(
          controller: pageController,
          count: survey.responseData.results.length,
          axisDirection: Axis.horizontal,
          effect: ScrollingDotsEffect(
            dotHeight: 4.0,
            activeDotColor: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
