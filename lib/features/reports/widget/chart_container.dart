import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/enums/sort_order.dart';
import 'package:kobo/core/helpers/extensions/question_type_ext.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/core/shared/models/submission_field.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/features/reports/widget/k_bar_chart.dart';
import 'package:kobo/features/reports/widget/k_line_chart.dart';
import 'package:kobo/features/reports/widget/k_pie_chart.dart';

class ChartContainer extends StatefulWidget {
  final KoboFormRepository? survey;

  const ChartContainer({super.key, this.survey});

  @override
  State<ChartContainer> createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  SurveyItem? selectedQuestion;
  bool _includeNull = false;
  int _chartIndex = 0; // 0: Bar, 1: Line, 2: Pie
  Map<String, int> xyData = {};
  Map<String, int>? xyDataRAW;
  SortOrder _currentSortOrder = SortOrder.raw;

  void updateData() {
    if (selectedQuestion == null) {
      if (mounted) {
        setState(() {});
      }
      return;
    }

    Map<String, int> newData = {};
    for (SubmissionData submissionData in widget.survey!.responseData.results) {
      SubmissionField? submissionField =
          submissionData.data[selectedQuestion!.name];

      if (!_includeNull && submissionField == null) {
        continue;
      }
      String key = submissionField?.fieldValue ?? context.tr('nullValue');
      String keyValue = widget.survey!.getLabel(key);
      newData[keyValue] = (newData[keyValue] ?? 0) + 1;
    }
    if (mounted) {
      setState(() {
        xyData = newData;
        xyDataRAW = Map.from(xyData);
      });
    }
  }

  void _sortData() {
    if (selectedQuestion == null) {
      return;
    }

    switch (_currentSortOrder) {
      case SortOrder.raw:
        xyData = Map.fromEntries(
          xyData.entries.toList()..sort((a, b) => a.value.compareTo(b.value)),
        );
        _currentSortOrder = SortOrder.ascending;
        break;

      case SortOrder.ascending:
        xyData = Map.fromEntries(
          xyData.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
        );
        _currentSortOrder = SortOrder.descending;
        break;

      case SortOrder.descending:
        xyData = Map.from(xyDataRAW!);
        _currentSortOrder = SortOrder.raw;
        break;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);

    Widget chartWidget;
    switch (_chartIndex) {
      case 0:
        chartWidget = KBarChart(xyData: xyData);
        break;
      case 1:
        chartWidget = KLineChart(xyData: xyData);
        break;
      case 2:
        chartWidget = KPieChart(xyData: xyData);
        break;
      default:
        chartWidget = const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,

        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              selectedQuestion == null
                  ? Text(context.tr('questions'))
                  : Expanded(
                    child: Text(
                      widget.survey!.getLabel(selectedQuestion!.name),
                    ),
                  ),
              PopupMenuButton<String>(
                itemBuilder: (BuildContext ctx) {
                  if (widget.survey == null) {
                    return [];
                  } else {
                    return widget.survey!.questions
                        .where((q) => !q.type.isGroupOrRepeat)
                        .map((question) {
                          return PopupMenuItem<String>(
                            enabled: selectedQuestion != question,
                            value: question.name,
                            child: Text(widget.survey!.getLabel(question.name)),
                            onTap: () {
                              selectedQuestion = question;
                              updateData();
                            },
                          );
                        })
                        .toList();
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: chartWidget,
          ),

          const Divider(),

          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton.icon(
                label: Text(
                  _includeNull
                      ? context.tr('nullValuesIncluded')
                      : context.tr('nullValuesExcluded'),
                  style: TextStyle(
                    color: _includeNull ? theme.colorScheme.error : null,
                  ),
                ),
                onPressed: () {
                  _includeNull = !_includeNull;
                  updateData();
                },
                icon: Icon(
                  _includeNull ? Icons.code : Icons.code_off,
                  color:
                      _includeNull
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                ),
              ),
              const Spacer(),

              TextButton.icon(
                label: Text(
                  _currentSortOrder == SortOrder.raw
                      ? context.tr('sort.raw')
                      : _currentSortOrder == SortOrder.ascending
                      ? context.tr('sort.ascending')
                      : context.tr('sort.descending'),
                  style: TextStyle(
                    color:
                        _currentSortOrder == SortOrder.raw
                            ? theme.colorScheme.primary
                            : _currentSortOrder == SortOrder.ascending
                            ? Colors.green
                            : theme.colorScheme.error,
                  ),
                ),
                onPressed: _sortData,
                icon: Icon(
                  _currentSortOrder == SortOrder.raw
                      ? Icons.swap_vert
                      : _currentSortOrder == SortOrder.ascending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color:
                      _currentSortOrder == SortOrder.raw
                          ? theme.colorScheme.primary
                          : _currentSortOrder == SortOrder.ascending
                          ? Colors.green
                          : theme.colorScheme.error,
                ),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    _chartIndex = (_chartIndex + 1) % 3;
                  });
                },
                icon: Icon(
                  _chartIndex == 0
                      ? Icons.bar_chart
                      : _chartIndex == 1
                      ? Icons.line_axis
                      : Icons.pie_chart,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
