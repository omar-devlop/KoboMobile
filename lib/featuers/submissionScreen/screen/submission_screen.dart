import 'package:flutter/material.dart';
import 'package:kobo/core/kobo_utils/validation_status.dart';
import 'package:kobo/data/modules/submission_data.dart';

class SubmissionScreen extends StatelessWidget {
  // final KoboForm kForm;
  final SubmissionData submissionData;
  const SubmissionScreen({
    super.key,
    // required this.kForm,
    required this.submissionData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            submissionData.metaInstanceName,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(submissionData.id.toString()),
          trailing: getValidationStatusIcon(
            validationLabel: submissionData.validationStatus?.label,
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: submissionData.data.entries.length,
        itemBuilder: (context, index) {
          final entry = submissionData.data.entries.elementAt(index);
          return ListTile(title: Text(entry.value), subtitle: Text(entry.key));
        },
      ),
    );
  }
}
