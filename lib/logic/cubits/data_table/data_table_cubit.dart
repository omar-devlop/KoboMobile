import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/enums/validation_types.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/kobo_utils/safe_index.dart';
import 'package:kobo/core/kobo_utils/validation_check.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/form_data.dart';
import 'package:kobo/data/modules/pluto_table.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:kobo/data/services/kobo_service.dart';
import 'package:pluto_grid/pluto_grid.dart';

part 'data_table_state.dart';
part 'data_table_cubit.freezed.dart';

class DataTableCubit extends Cubit<DataTableState> {
  DataTableCubit(String uid) : super(DataTableState.initial()) {
    setUid(uid);
    fetchTableData();
  }

  late String uid;
  SurveyData surveyData = SurveyData();
  PlutoTableData tableData = PlutoTableData();

  void safeEmit(DataTableState state) => !isClosed ? emit(state) : null;

  void setUid(String uid) => this.uid = uid;

  void fetchTableData() async {
    safeEmit(DataTableState.loading(msg: "Fetching survey..."));

    surveyData = await _fetchAsset();

    safeEmit(DataTableState.loading(msg: "Fetching data..."));

    surveyData.data = await _fetchData();

    safeEmit(DataTableState.loading(msg: "Handling columns..."));

    tableData.columns = _addColumns(labelIndex: 1);
    tableData.languages = surveyData.languages;

    safeEmit(DataTableState.loading(msg: "Handling data..."));

    tableData.rows = _addRows(labelIndex: 1);

    safeEmit(DataTableState.success(tableData));
  }

  Future<SurveyData> _fetchAsset() async =>
      await getIt<KoboService>().fetchFormAsset(uid: uid);

  Future<List<SubmissionBasicData>> _fetchData() async =>
      await getIt<KoboService>().fetchFormData(uid: uid);

  // -------------------------------------------------------------------------------------------

  void changeLanguage(int langIndex) {
    safeEmit(DataTableState.loading(msg: "Changing language..."));

    tableData.columns = _addColumns(labelIndex: langIndex);
    tableData.rows = _addRows(labelIndex: langIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeEmit(DataTableState.success(tableData));
    });
  }

  // -------------------------------------------------------------------------------------------

  List<PlutoColumn> _addColumns({int labelIndex = 0}) {
    List<PlutoColumn> newColumns = [];
    newColumns.add(
      PlutoColumn(
        title: "#",
        field: "index",
        type: PlutoColumnType.number(),
        readOnly: true,
      ),
    );
    newColumns.add(
      PlutoColumn(
        title: "Validation",
        field: "validation_status",
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        readOnly: true,
        renderer: (rendererContext) {
          Widget icon;
          switch (rendererContext.cell.value) {
            case ValidationTypes.approved:
              icon = const Icon(Icons.done, color: Colors.green);
              break;
            case ValidationTypes.notApproved:
              icon = const Icon(Icons.close, color: Colors.red);
              break;
            case ValidationTypes.onHold:
              icon = const Icon(Icons.priority_high, color: Colors.orange);
              break;

            default:
              icon = const SizedBox();
          }
          return icon;
        },
      ),
    );

    for (SurveyItem sItem in surveyData.survey) {
      if (sItem.type.contains('group') || sItem.type.contains('repeat')) {
        continue;
      }

      newColumns.add(
        PlutoColumn(
          title: sItem.labels.getIndexOrFirst(labelIndex), // sItem.type,
          field: sItem.name,
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
      );
    }

    return newColumns;
  }

  List<PlutoRow> _addRows({int labelIndex = 0}) {
    List<PlutoRow> newRows = [];

    int index = 1;
    for (SubmissionBasicData sBasicItem in surveyData.data) {
      Map<String, PlutoCell> cells = {};
      for (PlutoColumn column in tableData.columns) {
        if (column.field == "index") {
          cells[column.field] = PlutoCell(value: index);
          index++;
          continue;
        }
        if (column.field == "validation_status") {
          cells[column.field] = PlutoCell(
            value: sBasicItem.validationStatus.toValue(),
          );
          continue;
        }
        SurveyItem curColumn = surveyData.survey.firstWhere(
          (SurveyItem element) => element.name == column.field,
        );

        String? cellValue = sBasicItem.data[column.field];
        if (cellValue.isNullOrEmpty()) {
          cells[column.field] = PlutoCell(value: "");
          continue;
        }
        switch (curColumn.type) {
          case 'select_one':
            String newCellValue = surveyData.choices
                .firstWhere(
                  (ChoicesItem element) => (element.name == cellValue),
                )
                .labels
                .getIndexOrFirst(labelIndex);

            cells[column.field] = PlutoCell(value: newCellValue);

            continue;

          case 'select_multiple':
            List<String> cellValues = cellValue.toString().split(" ");
            List<String> newCellValues = [];

            for (String cellValueItem in cellValues) {
              newCellValues.add(
                surveyData.choices
                    .firstWhere(
                      (ChoicesItem element) => element.name == cellValueItem,
                    )
                    .labels
                    .getIndexOrFirst(labelIndex),
              );
            }

            cells[column.field] = PlutoCell(value: newCellValues.join(" "));

            continue;
          default:
        }

        cells[column.field] = PlutoCell(value: cellValue);
      }

      newRows.add(PlutoRow(cells: cells));
    }

    return newRows;
  }
}
