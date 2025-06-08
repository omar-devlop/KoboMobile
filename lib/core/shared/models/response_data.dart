import 'package:kobo/core/shared/models/submission_data.dart';

class ResponseData {
  late int count;
  late String? next;
  late String? previous;
  late List<SubmissionData> results;

  ResponseData({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  static ResponseData empty() {
    return ResponseData(count: 0, results: []);
  }
}
