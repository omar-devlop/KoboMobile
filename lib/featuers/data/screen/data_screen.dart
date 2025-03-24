import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/kobo_utils/validation_status.dart';
import 'package:kobo/core/utils/routing/navigation_route.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/data/modules/submission_data.dart';
import 'package:kobo/featuers/data/bloc/data_cubit.dart';
import 'package:kobo/core/utils/routing/open_container_navigation.dart';

class DataScreen extends StatelessWidget {
  final KoboForm kForm;
  const DataScreen({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${kForm.name} - Data')),
      body: BlocBuilder<DataCubit, DataState>(
        builder: (context, state) {
          return state.when(
            initial:
                () => Center(child: Column(children: [Text('Hello World!')])),
            loading:
                (msg) => Center(
                  child: Column(
                    spacing: 20.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [CircularProgressIndicator(), Text(msg)],
                  ),
                ),
            success: (data) {
              List<SubmissionData> submissionList = data.data?.results ?? [];
              if (submissionList.isNullOrEmpty()) {
                return Center(
                  child: Text('There is no data in this form "${kForm.name}"'),
                );
              } else {
                return ListView.builder(
                  itemCount: submissionList.length,
                  itemBuilder: (context, index) {
                    return OpenContainerNavigation(
                      openPage: getPage(
                        pageName: Routes.submissionScreen,
                        arguments: submissionList[index],
                      ),

                      child: (void Function() openContainer) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                          title: Text(submissionList[index].metaInstanceName),
                          trailing: getValidationStatusIcon(
                            validationLabel:
                                submissionList[index].validationStatus?.label,
                          ),
                          onTap: openContainer,
                        );
                      },
                    );
                  },
                );
              }
            },
            error: (error) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}
