import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/featuers/contentScreen/bloc/form_content_cubit.dart';

class ContentScreen extends StatelessWidget {
  final KoboForm kForm;
  const ContentScreen({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${kForm.name} - Content')),
      body: BlocBuilder<FormContentCubit, FormContentState>(
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
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].name),
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
