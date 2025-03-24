import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/utils/networking/dio_factory';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/featuers/home/bloc/kobo_forms_cubit.dart';
import 'package:kobo/featuers/home/widget/kobo_form_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> reFetchForms() async =>
      BlocProvider.of<KoboformsCubit>(context).fetchForms();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kobo App'),
        leading: IconButton(
          onPressed: () {
            DioFactory.removeCredentialsIntoHeader();
            context.pushReplacementNamed(Routes.loginScreen);
          },
          icon: Icon(Icons.logout),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(Routes.settingsScreen),
            icon: Icon(Icons.settings_outlined),
          ),
          SizedBox(width: 10),

          IconButton(onPressed: reFetchForms, icon: Icon(Icons.refresh)),
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
              // if (screenSize.width < 600) {
              //   return RefreshIndicator(
              //     onRefresh: reFetchForms,
              //     child: ListView.builder(
              //       itemCount: data.length,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 8.0,
              //             vertical: 4.0,
              //           ),
              //           child: KoboFormCard(kForm: data[index]),
              //         );
              //       },
              //     ),
              //   );
              // }

              return RefreshIndicator(
                onRefresh: reFetchForms,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        screenSize.width < 600
                            ? 1
                            : (screenSize.width / 300).toInt(),
                    childAspectRatio:
                        screenSize.width < 600 ? screenSize.width / 110 : 2.5,
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
