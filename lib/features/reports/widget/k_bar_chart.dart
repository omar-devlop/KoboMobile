import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KBarChart extends StatefulWidget {
  final Map<String, int> xyData;

  const KBarChart({super.key, required this.xyData});

  @override
  State<KBarChart> createState() => _KBarChartState();
}

class _KBarChartState extends State<KBarChart> {
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
  void didUpdateWidget(covariant KBarChart oldWidget) {
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
      maxYValue = yData.reduce((a, b) => a > b ? a : b).toDouble();
    } else {
      maxYValue = 0.0;
    }

    BarChartData data = BarChartData(
      minY: 0,
      maxY: maxYValue * 1.1,
      barTouchData: BarTouchData(
        enabled: false,
        handleBuiltInTouches: false,
        touchCallback: (event, response) {},
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipMargin: 0.0,
          tooltipPadding: EdgeInsets.zero,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            if (groupIndex < 0 || groupIndex >= yData.length) return null;
            return BarTooltipItem(
              yData[groupIndex].toString(),
              theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
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

      barGroups: List.generate(
        yData.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: _animatedYData[index].toDouble(),
              width: calculateWidth(xData.length),
              color: theme.colorScheme.primary,
              backDrawRodData: BackgroundBarChartRodData(
                color: theme.colorScheme.primary.withAlpha(20),
                toY: maxYValue,
                show: true,
              ),
            ),
          ],
          showingTooltipIndicators: [0],
          barsSpace: 4,
        ),
      ),
    );
    return GestureDetector(
      onDoubleTap: _transformationReset,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: AspectRatio(
        aspectRatio: 1.35,
        child: BarChart(
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

double calculateWidth(int length) {
  const double maxWidth = 20.0;
  const double minWidth = 2.0;
  const double scaleFactor = 2.0;

  if (length == 0) return maxWidth;

  double width = maxWidth / (1 + (length / scaleFactor));

  return width.clamp(minWidth, maxWidth);
}
