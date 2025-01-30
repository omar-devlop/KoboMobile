import 'package:flutter/material.dart';
import 'package:kobo/core/kobo_utils/validation_check.dart';
import 'package:kobo/data/modules/form_data.dart';

class FormDataSubmissionsList extends StatelessWidget {
  final List<SubmissionBasicData> data;
  final bool isLoading;
  final VoidCallback? loadMore;
  const FormDataSubmissionsList({
    super.key,
    required this.data,
    this.isLoading = false,
    this.loadMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        if (index == data.length) {
          if (isLoading) {
            return ListTile(
              subtitle: Center(child: LinearProgressIndicator()),
              title: Center(child: Text('Loading more data...')),
            );
          } else {
            return ListTile(
              title: Center(child: Text("Load more")),
              onTap: loadMore,
            );
          }
        }

        SubmissionBasicData kSubmission = data[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(kSubmission.metaInstanceName),
          trailing: kSubmission.validationStatus.toIcon(),
          subtitle: Text(
            kSubmission.id.toString(),
            style: TextStyle(fontWeight: FontWeight.w100),
          ),
        );
      },
    );
  }
}
