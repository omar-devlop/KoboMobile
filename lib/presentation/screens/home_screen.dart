import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/logic/cubits/kobo_forms/kobo_forms_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kobo App'),
        actions: [
          IconButton(
            onPressed: () =>
                BlocProvider.of<KoboformsCubit>(context).fetchForms(),
            icon: Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: BlocBuilder<KoboformsCubit, KoboformsState>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(
              child: Column(
                children: [
                  Text('Hello World!'),
                  FilledButton(
                    onPressed: () =>
                        BlocProvider.of<KoboformsCubit>(context).fetchForms(),
                    child: Text("getData"),
                  ),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            success: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return KoboFormCard(kForm: data[index]);
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

class KoboFormCard extends StatelessWidget {
  final KoboForm kForm;
  const KoboFormCard({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.pushNamed(Routes.formScreen, arguments: kForm),
      title: Text(kForm.name),
      subtitle: Text(kForm.deploymentSubmissionCount.toString()),
      trailing: Icon(Icons.arrow_right),
    );
  }
}
