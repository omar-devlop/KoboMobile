import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/shared/widget/language_selector.dart';
import 'package:kobo/features/data/bloc/data_cubit.dart';
import 'package:kobo/features/reports/widget/chart_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportScreen extends StatefulWidget {
  final KoboForm kForm;
  const ReportScreen({super.key, required this.kForm});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int selectedLangIndex = 1;
  int chartsCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          subtitle: Text(widget.kForm.name, overflow: TextOverflow.ellipsis),
          contentPadding: EdgeInsets.zero,
          title: Text(context.tr('reports'), overflow: TextOverflow.ellipsis),
        ),
        actions: [
          BlocBuilder<DataCubit, DataState>(
            builder: (context, state) {
              return state.when(
                initial: () => const SizedBox.shrink(),
                error: (_) => const SizedBox.shrink(),
                loading:
                    (_) => Skeletonizer(
                      enabled: true,
                      child: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ),

                success:
                    (survey, isLoadingMore, isUpdating) =>
                        SurveyLanguageSelector(
                          survey: survey,
                          selectedLangIndex: selectedLangIndex,

                          onSelected: (val) {
                            if (val == selectedLangIndex) return;
                            if (!mounted) return;
                            selectedLangIndex = val;

                            setState(() {
                              survey.languageIndex = val;
                            });
                          },
                        ),
              );
            },
          ),
          const ActionsSpacing(),
        ],
      ),

      body: BlocBuilder<DataCubit, DataState>(
        builder: (context, state) {
          KoboFormRepository? survey;
          if (state is Success) {
            survey = state.data;
          }
          return Skeletonizer(
            enabled: state is! Success,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              children: [
                ...List.generate(
                  chartsCount,
                  (index) => Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ChartContainer(survey: survey, key: ValueKey(index)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: TextButton.icon(
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          chartsCount++;
                        });
                      }
                    },
                    label: Text(context.tr('addNewChart')),
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
