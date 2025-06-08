import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/enums/time_period.dart';
import 'package:kobo/core/helpers/help_func.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/features/form/bloc/submission_stats_cubit.dart';
import 'package:kobo/features/reports/widget/k_bar_chart.dart';
import 'package:kobo/features/reports/widget/k_line_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubmissionActivityOverview extends StatefulWidget {
  final KoboForm kForm;
  const SubmissionActivityOverview({super.key, required this.kForm});

  @override
  State<SubmissionActivityOverview> createState() =>
      _SubmissionActivityOverviewState();
}

class _SubmissionActivityOverviewState
    extends State<SubmissionActivityOverview> {
  TimePeriod _timePeriod = TimePeriod.past7Days;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SubmissionStatsCubit(widget.kForm.uid),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('submissionActivityOverview'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  BlocBuilder<SubmissionStatsCubit, SubmissionStatsState>(
                    builder: (context, state) {
                      return Skeletonizer(
                        enabled: state is Loading,
                        child: PopupMenuButton<int>(
                          enabled: state is! Loading,
                          icon: IgnorePointer(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.bar_chart),
                              label: Text(
                                context.tr(_timePeriod.label),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          itemBuilder: (BuildContext ctx) {
                            return TimePeriod.values.map((entry) {
                              String key = entry.label;
                              int val = entry.days;
                              return PopupMenuItem<int>(
                                value: val,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.done,
                                      color:
                                          val == _timePeriod.days
                                              ? theme.colorScheme.primary
                                              : Colors.transparent,
                                    ),
                                    const ActionsSpacing(),
                                    Text(
                                      context.tr(key),
                                      style: TextStyle(
                                        fontWeight:
                                            val == _timePeriod.days
                                                ? FontWeight.bold
                                                : null,
                                        color:
                                            val == _timePeriod.days
                                                ? theme.colorScheme.primary
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      _timePeriod = entry;
                                    });
                                  }
                                  context
                                      .read<SubmissionStatsCubit>()
                                      .fetchSubmissionStatsData(
                                        days: _timePeriod.days,
                                      );
                                },
                              );
                            }).toList();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),

              BlocBuilder<SubmissionStatsCubit, SubmissionStatsState>(
                builder: (context, state) {
                  Map<String, int> xyData = _prepareCountsAsStringKeys(
                    dailySubmissionCounts:
                        (state is Success)
                            ? state.submissionStats.dailySubmissionCounts
                            : {},
                    selectedPeriod: _timePeriod,
                    context: context,
                  );
                  return Skeletonizer(
                    enabled: state is Loading,
                    child: Column(
                      children: [
                        KBarChart(xyData: xyData),
                        Divider(color: theme.colorScheme.onInverseSurface),
                        KLineChart(xyData: xyData),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, int> _prepareCountsAsStringKeys({
  required Map<DateTime, int> dailySubmissionCounts,
  required TimePeriod selectedPeriod,
  required BuildContext context,
}) {
  Map<DateTime, int> normalizedDailyCounts = {};
  DateTime normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  dailySubmissionCounts.forEach((key, value) {
    final normalizedKey = normalizeDate(key);
    normalizedDailyCounts[normalizedKey] =
        (normalizedDailyCounts[normalizedKey] ?? 0) + value;
  });

  final now = DateTime.now();

  List<DateTime> xDates;
  Map<DateTime, int> counts = {};

  if (selectedPeriod == TimePeriod.past3Months ||
      selectedPeriod == TimePeriod.past12Months) {
    final months = selectedPeriod == TimePeriod.past3Months ? 3 : 12;
    xDates = List.generate(months, (i) {
      return DateTime(now.year, now.month - (months - i - 1), 1);
    });

    for (var monthStart in xDates) {
      final year = monthStart.year;
      final month = monthStart.month;

      final totalForMonth = normalizedDailyCounts.entries
          .where((e) => e.key.year == year && e.key.month == month)
          .fold<int>(0, (prev, e) => prev + e.value);

      counts[monthStart] = totalForMonth;
    }
  } else {
    final days = selectedPeriod.days;
    xDates = List.generate(
      days,
      (i) => normalizeDate(now.subtract(Duration(days: days - i - 1))),
    );

    counts = {for (var d in xDates) d: normalizedDailyCounts[d] ?? 0};
  }

  const Map<TimePeriod, String> datePatterns = {
    TimePeriod.past7Days: 'dd MMM',
    TimePeriod.past31Days: 'MMM dd',
    TimePeriod.past3Months: 'MMMM',
    TimePeriod.past12Months: 'MMM',
  };

  final pattern = datePatterns[selectedPeriod]!;

  Map<String, int> stringKeyCounts = {
    for (var entry in counts.entries)
      getFormattedDate(context, entry.key.toString(), pattern: pattern):
          entry.value,
  };

  return stringKeyCounts;
}
