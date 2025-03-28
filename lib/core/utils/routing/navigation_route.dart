import 'package:flutter/material.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/data/modules/submission_data.dart';
import 'package:kobo/featuers/submission/screen/submission_screen.dart';
import 'package:kobo/presentation/screens/empty/empty_screen.dart';
import 'package:kobo/presentation/screens/form/form_screen.dart';

Widget getPage({required String pageName, dynamic arguments}) {
  switch (pageName) {
    case Routes.formScreen: // FORM
      KoboForm kForm = arguments as KoboForm;
      return FormScreen(kForm: kForm);

    case Routes.submissionScreen: // SUBMISSION
      SubmissionData kForm = arguments as SubmissionData;
      return SubmissionScreen(submissionData: kForm);

    default:
      return const EmptyScreen();
  }
}
