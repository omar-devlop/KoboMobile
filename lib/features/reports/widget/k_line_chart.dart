import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KLineChart extends StatefulWidget {
  final Map<String, int> xyData;

  const KLineChart({super.key, required this.xyData});

  @override
  State<KLineChart> createState() => _KLineChartState();
}

class _KLineChartState extends State<KLineChart> {
  List<String> xData = [];
  List<int> yData = [];
  late List<int> _animatedYData;

  late TransformationController _transformationController;

  _updateData() {
    xData = widget.xyData.keys.toList();
    _animatedYData = List.generate(xData.length, (index) => 0);
    yData = widget.xyData.values.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animatedYData = List<int>.from(yData);
      });
    });
  }

  @override
  void didUpdateWidget(covariant KLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.xyData != widget.xyData) {
      _updateData();
    }
  }

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _updateData();
  }

  Matrix4? _initialMatrix;

  void _onScaleStart(ScaleStartDetails details) {
    _initialMatrix = _transformationController.value.clone();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_initialMatrix == null) return;

    final Matrix4 matrix =
        Matrix4.identity()
          ..translate(details.focalPointDelta.dx, details.focalPointDelta.dy)
          ..scale(details.scale);

    _transformationController.value = _initialMatrix!.multiplied(matrix);
  }

  void _transformationReset() {
    _transformationController.value = Matrix4.identity();
  }

  bool get isEmpty => !widget.xyData.values.any((element) => element > 0);

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

    double maxYValue;
    if (yData.isNotEmpty) {
      maxYValue = yData.reduce((a, b) => a > b ? a : b) * 1.1;
    } else {
      maxYValue = 0.0;
    }

    LineChartData data = LineChartData(
      minY: 0,
      maxY: maxYValue,
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      lineTouchData: LineTouchData(
        enabled: true,
        getTouchedSpotIndicator:
            (barData, spotIndexes) =>
                spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withAlpha(50),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    const FlDotData(show: false),
                  );
                }).toList(),
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,

          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${yData[spot.x.toInt()]}\n${xData[spot.x.toInt()]}',
                theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: _bottomTitle,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            yData.length,
            (index) =>
                FlSpot(index.toDouble(), _animatedYData[index].toDouble()),
          ),

          color: theme.colorScheme.primary,
          barWidth: 2,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: theme.colorScheme.primary.withAlpha(50),
          ),
        ),
      ],
    );
    return GestureDetector(
      onDoubleTap: _transformationReset,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: AspectRatio(
        aspectRatio: 1.35,
        child: LineChart(
          data,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          transformationConfig: FlTransformationConfig(
            scaleAxis: FlScaleAxis.horizontal,
            minScale: 1.0,
            maxScale: 25.0,
            panEnabled: true,
            scaleEnabled: true,
            transformationController: _transformationController,
          ),
        ),
      ),
    );
  }

  Widget _bottomTitle(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        xData.isNotEmpty ? xData[value.toInt()] : '',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
