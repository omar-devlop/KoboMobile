import 'package:kobo/core/enums/question_type.dart';

/// Represents a field from the submission that has a value and its full path.
class SubmissionField {
  late dynamic fieldValue;
  late String fullPath;
  late QuestionType fieldType;
  SubmissionField(
    this.fieldValue,
    this.fullPath, {
    this.fieldType = QuestionType.unknown,
  });

  SubmissionField.fromRawEntry(
    String rawKey,
    dynamic rawValue, {
    QuestionType? fieldType,
  }) {
    fieldValue = rawValue;
    fullPath = rawKey;
    fieldType = fieldType;
  }
}
