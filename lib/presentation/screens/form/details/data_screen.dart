import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/logic/cubits/form_data/form_data_cubit.dart';
import 'package:kobo/presentation/widgets/form_data_submissions_list.dart';

class DataScreen extends StatelessWidget {
  final KoboForm kForm;
  const DataScreen({
    super.key,
    required this.kForm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${kForm.name} - Data'),
      ),
      body: BlocBuilder<FormDataCubit, FormDataState>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(
              child: Column(
                children: [
                  Text('Hello World!'),
                ],
              ),
            ),
            loading: (data) {
              if (data.results.isEmpty) return const LinearProgressIndicator();
              return FormDataSubmissionsList(data: data.results, isLoading: true);
            },
            success: (data) {
              return FormDataSubmissionsList(
                data: data.results,
                loadMore: () => BlocProvider.of<FormDataCubit>(context)
                    .fetchMoreData(kForm.uid),
              );
            },
            error: (error) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}
