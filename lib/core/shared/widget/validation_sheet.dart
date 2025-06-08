import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/enums/validation_type.dart';
import 'package:kobo/core/helpers/extensions/build_context_ext.dart';
import 'package:kobo/core/helpers/extensions/widget_animation_ext.dart';
import 'package:kobo/core/helpers/help_func.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/widget/label_widget.dart';
import 'package:kobo/core/shared/widget/validation_type_card.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

Future<bool?> openValidationSheet(
  BuildContext context, {
  required String uid,
  required List<int> submissionIds,
}) async => await showModalBottomSheet<bool>(
  context: context,
  isScrollControlled: true,
  builder:
      (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _DraggableSheetContent(uid: uid, submissionIds: submissionIds),
      ),
);

class _DraggableSheetContent extends StatefulWidget {
  final String uid;
  final List<int> submissionIds;
  const _DraggableSheetContent({
    required this.uid,
    required this.submissionIds,
  });
  @override
  State<_DraggableSheetContent> createState() => _DraggableSheetContentState();
}

class _DraggableSheetContentState extends State<_DraggableSheetContent> {
  final _sheetController = DraggableScrollableController();
  double _currentExtent = 0.5;

  ValidationType? _isLoading;

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
              tr('validation'),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            LabelWidget(
              title:
                  '${widget.submissionIds.length.toString()} ${tr('submission')}',
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

      builder: (ctx, scrollController) {
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
                ...ValidationType.values.map(
                  (validationType) => ValidationTypeCard(
                    validationType: validationType,
                    isLoading: _isLoading == validationType,
                  ).tapScale(
                    enabled: _isLoading == null,
                    onTap: () async {
                      if (!context.mounted) return;
                      setState(() => _isLoading = validationType);
                      bool isChanged = await getIt<KoboService>()
                          .validatteSubmissionStatus(
                            uid: widget.uid,
                            submissionIds: widget.submissionIds,
                            validationType: validationType,
                          );
                      if (context.mounted) {
                        context.pop(true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isChanged
                                  ? tr('validation_status_updated')
                                  : tr('validation_status_not_updated'),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
