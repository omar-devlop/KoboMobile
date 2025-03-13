import 'package:flutter/material.dart';
import 'package:kobo/core/kobo_utils/safe_index.dart';
import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/form_data.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KoboFormDataSource extends DataGridSource {
  KoboFormDataSource({
    required List<GridColumn> gridColumns,
    required SurveyData surveyData,
  }) : _gridColumns = gridColumns,
       _koboDataList = surveyData.data,
       _surveyData = surveyData {
    buildDataGridRows();
  }
  List<GridColumn> _gridColumns;
  List<SubmissionBasicData> _koboDataList;
  final SurveyData _surveyData;
  List<DataGridRow> _koboDataRows = [];

  void buildDataGridRows({int languageIndex = 1}) {
    _koboDataRows =
        _koboDataList.asMap().entries.map((entry) {
          final index = entry.key + 1; // Generate row number
          final item = entry.value;

          final cells =
              _gridColumns.map<DataGridCell<dynamic>>((column) {
                String colName = column.columnName;
                String cellValue = item.data[colName] ?? '';

                if (colName == '#') {
                  return DataGridCell<int>(columnName: '#', value: index);
                }

                if (cellValue != '') {
                  int surveyItemIndex = _surveyData.survey.indexWhere(
                    (element) => element.name == colName,
                  );
                  SurveyItem? surveyItem;

                  if (surveyItemIndex >= 0) {
                    surveyItem = _surveyData.survey[surveyItemIndex];

                    if (surveyItem.type.contains('select')) {
                      if (surveyItem.type.contains('multiple')) {
                        List<String> cellValues = cellValue.toString().split(
                          " ",
                        );
                        List<String> newCellValues = [];

                        for (String cellValueItem in cellValues) {
                          newCellValues.add(
                            _surveyData.choices
                                .firstWhere(
                                  (ChoicesItem element) =>
                                      element.name == cellValueItem,
                                )
                                .labels
                                .getIndexOrFirst(languageIndex),
                          );
                        }
                        cellValue = newCellValues.join(" ");

                      } else {

                        cellValue = _surveyData.choices
                            .firstWhere((element) => element.name == cellValue)
                            .labels
                            .getIndexOrFirst(languageIndex);

                      }
                    }
                  }
                }

                return DataGridCell<String>(
                  columnName: colName,
                  value: cellValue,
                );
              }).toList();

          return DataGridRow(cells: cells);
        }).toList();
  }

  @override
  List<DataGridRow> get rows => _koboDataRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((e) {
            return Container(
              alignment: Alignment.center,
              child: Text(e.value.toString(), overflow: TextOverflow.ellipsis),
            );
          }).toList(),
    );
  }

  // Call this when columns or data changes
  void refreshDataGrid({
    List<GridColumn>? newColumns,
    List<SubmissionBasicData>? newData,
    int languageIndex = 1,
  }) {
    if (newColumns != null) _gridColumns = newColumns;
    if (newData != null) _koboDataList = newData;
    buildDataGridRows(languageIndex: languageIndex);
    notifyListeners();
  }
}
