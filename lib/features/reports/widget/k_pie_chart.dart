import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/help_func.dart';

class KPieChart extends StatefulWidget {
  final Map<String, int> xyData;

  const KPieChart({super.key, required this.xyData});

  @override
  State<KPieChart> createState() => _KPieChartState();
}

class _KPieChartState extends State<KPieChart> {
  List<String> xData = [];
  List<int> yData = [];
  int? _yTotal;

  _updateData() {
    xData = widget.xyData.keys.toList();
    yData = widget.xyData.values.toList();
  }

  @override
  void didUpdateWidget(covariant KPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.xyData != widget.xyData) {
      _updateData();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  bool get isEmpty => !widget.xyData.values.any((element) => element > 0);
  int get getTotal {
    if (_yTotal != null) {
      return _yTotal!;
    }
    _yTotal = yData.fold<int>(0, (sum, val) => sum + val);
    return _yTotal!;
  }

  String getTitle(int index) {
    final percentage = (yData[index] / getTotal) * 100;
    return '${percentage.toStringAsFixed(1)}%\n${xData[index]}';
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (widget.xyData.entries.isEmpty || isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            context.tr('noChartData'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      );
    }

    PieChartData data = PieChartData(
      centerSpaceRadius: 40,
      sectionsSpace: 4.0,
      sections: [
        for (int i = 0; i < xData.length; i++)
          PieChartSectionData(
            color: getRndColor(i),
            value: yData[i].toDouble(),
            title: getTitle(i),
            titleStyle: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            radius: 60,
            titlePositionPercentageOffset: 0.6,
          ),
      ],
    );
    return Column(
      spacing: 12.0,
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: PieChart(
            data,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(
            xData.length,
            (index) => Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6.0,
              children: [
                Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.only(right: 6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getRndColor(index),
                  ),
                ),
                Text(xData[index], style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
