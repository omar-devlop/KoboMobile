import 'package:kobo/data/modules/submission_data.dart';

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

  static Future<ResponseData> empty() async {
    return ResponseData(count: 0, results: []);
  }
}
