import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/logic/cubits/form_content/form_content_cubit.dart';

class KoboFormContentScreen extends StatelessWidget {
  final KoboForm kForm;
  const KoboFormContentScreen({
    super.key,
    required this.kForm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${kForm.name} - Content'),
      ),
      body: BlocBuilder<FormContentCubit, FormContentState>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(
              child: Column(
                children: [
                  Text('Hello World!'),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            success: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${data[index].name}",
                    ),
                    subtitle: Text("${data[index].type} (${data[index].kuid})"),
                  );
                },
              );
            },
            error: (error) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}
