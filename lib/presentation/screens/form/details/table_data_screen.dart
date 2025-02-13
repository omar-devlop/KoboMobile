import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/kobo_utils/safe_index.dart';
import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/form_data.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:kobo/logic/cubits/form_assets/form_asset_cubit.dart';
import 'package:kobo/logic/cubits/form_data/form_data_cubit.dart';
import 'package:kobo/presentation/widgets/table_view.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableDataScreen extends StatelessWidget {
  final KoboForm kForm;
  const TableDataScreen({
    super.key,
    required this.kForm,
  });

  @override
  Widget build(BuildContext context) {
    final List<PlutoColumn> columns = <PlutoColumn>[];
    final List<PlutoRow> rows = <PlutoRow>[];
    final Map<String, SurveyItem> columnsMap = {};

    void addColumns(List<SurveyItem> columnsData) {
      for (SurveyItem sItem in columnsData) {
        if (sItem.type.contains('group')) {
          continue;
        }
        if (sItem.type.contains('repeat')) {
          // handle repeat groups
          continue;
        }
        

        if (columns
            .where((pColumn) => pColumn.field == sItem.name)
            .isNotEmpty) {
          continue;
        }
        columnsMap.addAll({sItem.name: sItem});

        columns.add(
          PlutoColumn(
            title: sItem.label.getIndexOrFirst(1), // sItem.type,
            field: sItem.name,
            type: PlutoColumnType.text(),
          ),
        );
      }
    }

    List<PlutoRow> addRows(
        List<SubmissionBasicData> rowsData, List<ChoicesItem> columnsChoices) {
      for (SubmissionBasicData sBasicItem in rowsData) {
        Map<String, PlutoCell> cells = {};
        for (PlutoColumn column in columns) {
          SurveyItem curColumn = columnsMap[column.field]!;
          if (curColumn.type.contains('select_one')) {
     
            print("HERE: ${column.field}"); // TODO: refactoring this and make it easliy editable
            try {
              cells[column.field] = PlutoCell(
                value: columnsChoices   
                    .firstWhere((ChoicesItem element) =>
                        (element.name == sBasicItem.data[column.field]))
                    .label
                    .getIndexOrFirst(1),
              );
            } catch (e) {
              cells[column.field] =
                  PlutoCell(value: sBasicItem.data[column.field] ?? "");
            }

            continue;
          }
          cells[column.field] =
              PlutoCell(value: sBasicItem.data[column.field] ?? "");
        }

        rows.add(
          PlutoRow(cells: cells),
        );
      }
      return rows;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${kForm.name} - Table Data'),
      ),
      body: BlocBuilder<FormAssetCubit, FormAssetState>(
        builder: (context, state) {
          return state.when(
            initial: () => SizedBox(),
            loading: () => const LinearProgressIndicator(),
            success: (columnsData) {
              addColumns(columnsData.survey);

              return BlocBuilder<FormDataCubit, FormDataState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => Text('initial:'),
                    loading: (data) {
                      return Stack(
                        children: [
                          TableView(columns: columns),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    },
                    error: (error) => Text('Error: $error'),
                    success: (rowsData) {
                      return TableView(
                        columns: columns,
                        rows: addRows(rowsData, columnsData.choices),
                      );
                    },
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
