import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/shared/models/submission_data.dart';

extension SubmissionDataExtension on SubmissionData {
  dynamic getFirstByQuestionType(QuestionType questionType) {
    for (var element in data.entries) {
      if (element.value.fieldType == questionType) {
        return element.value.fieldValue;
      }
    }
    return null;
  }
}
