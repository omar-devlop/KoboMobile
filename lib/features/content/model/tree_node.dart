import 'package:kobo/core/shared/models/survey_item.dart';

class TreeNode {
  final String title;
  final List children;

  TreeNode({required this.title, this.children = const []});
}

class QuestionNode extends TreeNode {
  final SurveyItem question;

  QuestionNode({required super.title, super.children, required this.question});
}
