class SubmissionStats {
  final Map<DateTime, int> dailySubmissionCounts;
  final int? totalSubmissionCount;

  SubmissionStats({
    required this.dailySubmissionCounts,
    this.totalSubmissionCount,
  });

  factory SubmissionStats.fromJson(Map<String, dynamic> json) {
    final rawCounts =
        (json['daily_submission_counts'] ?? {}) as Map<String, dynamic>;

    final parsedCounts = Map.fromEntries(
      rawCounts.entries
          .map(
            (entry) => MapEntry(DateTime.parse(entry.key), entry.value as int),
          )
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );
    return SubmissionStats(
      dailySubmissionCounts: parsedCounts,
      totalSubmissionCount: (json['total_submission_count'] ?? 0) as int,
    );
  }

  static SubmissionStats empty() {
    return SubmissionStats(dailySubmissionCounts: {}, totalSubmissionCount: 0);
  }
}
