import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/shared/widget/language_selector.dart';
import 'package:kobo/features/content/bloc/form_content_cubit.dart';
import 'package:kobo/features/content/model/tree_node.dart';
import 'package:kobo/features/content/widget/tree_node_widget.dart';

class ContentScreen extends StatefulWidget {
  final KoboForm kForm;

  const ContentScreen({super.key, required this.kForm});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  int selectedLangIndex = 1;
  List<QuestionNode> _treeData = [];
  KoboFormRepository? survey;
  List<QuestionNode> buildTreeFromSurvey(List<SurveyItem> questions) {
    // Root list to return
    final List<QuestionNode> root = [];

    // Stack of lists: each entry is the children list of the current open group
    final List<List> stack = [root];

    for (final question in questions) {
      switch (question.type) {
        case QuestionType.beginGroup:
          final title = survey!.getLabel(question.name);

          // Create a new group node
          final groupNode = QuestionNode(
            title: title,
            children: <QuestionNode>[],
            question: question,
          );
          // Add to current parent
          stack.last.add(groupNode);
          // Push its children list onto stack
          stack.add(groupNode.children);
          break;

        case QuestionType.endGroup:
          // Close the current group
          if (stack.length > 1) {
            stack.removeLast();
          }
          break;

        default:
          // Regular question/item: create a leaf node
          // You can customize the title: use autoname or qpath if you like
          final title = survey!.getLabel(question.name);

          stack.last.add(QuestionNode(title: title, question: question));
      }
    }

    return root;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<FormContentCubit, FormContentState>(
      builder: (_, state) {
        return Scaffold(
          appBar: AppBar(
            title: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              subtitle: Text(
                widget.kForm.name,
                overflow: TextOverflow.ellipsis,
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                context.tr('questions'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            actions: [
              state.maybeWhen(
                success:
                    (survey) => SurveyLanguageSelector(
                      survey: survey,
                      selectedLangIndex: selectedLangIndex,
                      onSelected: (val) {
                        if (val == selectedLangIndex) return;
                        if (!mounted) return;
                        selectedLangIndex = val;
                        setState(() {
                          survey.languageIndex = val;
                        });
                      },
                    ),
                orElse: () => const SizedBox.shrink(),
              ),

              const ActionsSpacing(),
            ],
          ),
          body: state.when(
            loading:
                (msg) => Center(
                  child: Column(
                    spacing: 20.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      Text(
                        msg,
                        style: TextStyle(color: theme.colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
            success: (surveyData) {
              survey = surveyData;
              var questions = survey!.questions;
              _treeData = buildTreeFromSurvey(questions);
              return ListView(
                physics: const BouncingScrollPhysics(),

                padding: const EdgeInsets.all(16.0),
                children:
                    _treeData
                        .map((node) => TreeNodeWidget(node: node, depth: 0))
                        .toList(),
              );
            },
            error: (error) => Center(child: Text('Error: $error')),
          ),
        );
      },
    );
  }
}
