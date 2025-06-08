enum TimePeriod { past7Days, past31Days, past3Months, past12Months }

extension TimePeriodExtension on TimePeriod {
  String get label {
    switch (this) {
      case TimePeriod.past7Days:
        return 'past_7_days';
      case TimePeriod.past31Days:
        return 'past_31_days';
      case TimePeriod.past3Months:
        return 'past_3_months';
      case TimePeriod.past12Months:
        return 'past_12_months';
    }
  }

  int get days {
    switch (this) {
      case TimePeriod.past7Days:
        return 7;
      case TimePeriod.past31Days:
        return 31;
      case TimePeriod.past3Months:
        return 93;
      case TimePeriod.past12Months:
        return 366;
    }
  }
}
