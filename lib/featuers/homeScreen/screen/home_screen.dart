import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/featuers/homeScreen/bloc/kobo_forms_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> reFetchForms() async {
    BlocProvider.of<KoboformsCubit>(context).fetchForms();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kobo App'),
        actions: [
          IconButton(
            onPressed:
                () => BlocProvider.of<KoboformsCubit>(context).fetchForms(),
            icon: Icon(Icons.refresh),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<KoboformsCubit, KoboformsState>(
        builder: (context, state) {
          return state.when(
            initial:
                () => Center(
                  child: Column(
                    children: [
                      Text('Hello World!'),
                      FilledButton(
                        onPressed:
                            () =>
                                BlocProvider.of<KoboformsCubit>(
                                  context,
                                ).fetchForms(),
                        child: Text("getData"),
                      ),
                    ],
                  ),
                ),
            loading:
                (msg) => Center(
                  child: Column(
                    spacing: 20.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      if (msg != null) Text(msg),
                    ],
                  ),
                ),
            success: (data) {
              if (screenSize.width < 600) {
                return RefreshIndicator(
                  onRefresh: reFetchForms,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: KoboFormCard(kForm: data[index]),
                      );
                    },
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: reFetchForms,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (screenSize.width / 300).toInt(),
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return KoboFormCard(kForm: data[index]);
                  },
                ),
              );
            },
            error: (error) => Text('Error: $error'),
          );
        },
      ),
      // bottomNavigationBar: NavigationBar(
      //   labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      //   destinations: [
      //     NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      //     NavigationDestination(
      //       icon: Icon(Icons.settings_outlined),
      //       label: 'Settings',
      //     ),
      //         NavigationDestination(
      //       icon: Icon(Icons.person_outline),
      //       label: 'Account',
      //     ),
      //   ],
      // ),
    );
  }
}

class KoboFormCard extends StatelessWidget {
  final KoboForm kForm;
  const KoboFormCard({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Tooltip(
      message: kForm.name,
      child: GestureDetector(
        onTap: () => context.pushNamed(Routes.formScreen, arguments: kForm),
        child: Container(
          padding: EdgeInsets.only(top: 16.0, bottom: 12, left: 12, right: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer, // surfaceContainerLow
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kForm.name,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    kForm.ownerUsername,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  if (kForm.deploymentSubmissionCount != 0)
                    Text(
                      kForm.deploymentSubmissionCount.toString(),
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  Spacer(),
                  IconButton(
                    color: theme.primaryColor,
                    onPressed:
                        () => context.pushNamed(
                          Routes.contentScreen,
                          arguments: kForm,
                        ),
                    icon: Icon(Icons.question_answer_outlined),
                    tooltip: 'Questions',
                  ),
                  IconButton(
                    color: theme.primaryColor,
                    onPressed:
                        kForm.hasDeployment
                            ? () => context.pushNamed(
                              Routes.sTableDataScreen,
                              arguments: kForm,
                            )
                            : null,
                    icon: Icon(Icons.table_rows_outlined),
                    tooltip: 'Table',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
