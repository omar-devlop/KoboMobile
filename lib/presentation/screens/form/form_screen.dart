import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';

class FormScreen extends StatelessWidget {
  final KoboForm kForm;
  const FormScreen({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kForm.name)),
      body: GridView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width < 800 ? 2 : 6,
          childAspectRatio: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            enabled: kForm.hasDeployment,
            title: Text('S Table Data'),
            onTap:
                () => context.pushNamed(
                  Routes.sTableDataScreen,
                  arguments: kForm,
                ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kForm.deploymentSubmissionCount.toString()),
                Text(kForm.ownerUsername.toString()),
              ],
            ),
          ),
          // ---------------------------------
          SizedBox(),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            title: Text('Content'),
            onTap:
                () => context.pushNamed(Routes.contentScreen, arguments: kForm),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            enabled: kForm.hasDeployment,
            title: Text('Data'),
            onTap: () => context.pushNamed(Routes.dataScreen, arguments: kForm),
          ),
        ],
      ),
    );
  }
}
