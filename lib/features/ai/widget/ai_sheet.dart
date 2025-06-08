import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/help_func.dart';
import 'package:kobo/core/shared/widget/label_widget.dart';
import 'package:kobo/features/ai/bloc/cloudflare_ai_cubit.dart';
import 'package:kobo/features/ai/widget/suggestion_card.dart';

void openAiSheet(
  BuildContext context, {
  required String title,
  required String phrase,
}) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder:
      (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BlocProvider(
          create: (context) => CloudflareAiCubit(phrase),
          child: _DraggableSheetContent(title: title),
        ),
      ),
);

class _DraggableSheetContent extends StatefulWidget {
  final String title;

  const _DraggableSheetContent({required this.title});
  @override
  State<_DraggableSheetContent> createState() => _DraggableSheetContentState();
}

class _DraggableSheetContentState extends State<_DraggableSheetContent> {
  final _sheetController = DraggableScrollableController();
  double _currentExtent = 0.5;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(() {
      setState(() {
        _currentExtent = _sheetController.size;
      });
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;
    Radius radius = Radius.circular(
      _currentExtent < 0.9
          ? 24.0
          : mapValue(
            _currentExtent,
            inputMin: 0.9,
            inputMax: 1.0,
            outputMin: 24.0,
            outputMax: 0.0,
          ),
    );

    Widget buildBackgroundContainer() {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
        ),
      );
    }

    Widget buildHeader() {
      return SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            LabelWidget(
              title: tr('aiGenerated'),
              icon: Icons.auto_awesome,
              backgroundColor: theme.colorScheme.surface,
              forgroundColor: theme.colorScheme.primary,
            ),
          ],
        ),
      );
    }

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 1.0,
      snap: true,
      snapSizes: const [0.5, 1.0],
      snapAnimationDuration: const Duration(milliseconds: 100),
      expand: false,
      builder: (context, scrollController) {
        return BlocBuilder<CloudflareAiCubit, CloudflareAiState>(
          builder: (context, state) {
            return Stack(
              children: [
                buildBackgroundContainer(),
                ListView(
                  padding: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                    top: 36.0,
                  ),
                  controller: scrollController,
                  children: [
                    buildHeader(),
                    ...state.when(
                      loading:
                          () => [
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenSize.height * _currentExtent / 3,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                      success:
                          (response) =>
                              response
                                  .map((item) => SuggestionCard(title: item))
                                  .toList(),
                      error:
                          (error) => [
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenSize.height * _currentExtent / 3,
                              ),
                              child: Center(child: Text('Error: $error')),
                            ),
                          ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
