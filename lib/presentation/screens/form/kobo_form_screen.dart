import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';

class KoboFormScreen extends StatelessWidget {
  final KoboForm kForm;
  const KoboFormScreen({
    super.key,
    required this.kForm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kForm.name),
      ),
      body: GridView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kForm.deploymentSubmissionCount.toString()),
                Text(kForm.ownerUsername.toString()),
              ],
            ),
          ),
          SizedBox(),
          // ---------------------------------
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            title: Text('Content'),
            onTap: () =>
                context.pushNamed(Routes.formContentScreen, arguments: kForm),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            enabled: kForm.hasDeployment,
            title: Text('Data'),
            onTap: () =>
                context.pushNamed(Routes.formDataScreen, arguments: kForm),
          ),
        ],
      ),
    );
  }
}
