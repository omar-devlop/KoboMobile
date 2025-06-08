import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/shared/models/attachment.dart';
import 'package:kobo/core/shared/widget/attachment_container.dart';

class AttachmentsScrollView extends StatelessWidget {
  final List<Attachment> attachmentsValue;
  const AttachmentsScrollView({super.key, required this.attachmentsValue});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (attachmentsValue.isEmpty) {
      return Center(
        child: Text(
          context.tr('noAttachments'),
          style: TextStyle(color: theme.colorScheme.secondary),
        ),
      );
    }

    List<Widget> sliversList = [];
    for (Attachment attachment in attachmentsValue) {
      sliversList.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AttachmentContainer(attachment: attachment),
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: sliversList,
      ),
    );
  }
}
