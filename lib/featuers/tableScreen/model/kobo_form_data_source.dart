import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/kobo_utils/safe_index.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/response_data.dart';
import 'package:kobo/data/modules/submission_data.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:kobo/data/modules/validation_status.dart';
import 'package:kobo/data/services/kobo_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KoboFormDataSource extends DataGridSource {
  KoboFormDataSource({
    required List<GridColumn> gridColumns,
    required SurveyData surveyData,
  }) : _gridColumns = gridColumns,
       _koboDataList = [],
       _surveyData = surveyData;
  List<GridColumn> _gridColumns;
  List<SubmissionData> _koboDataList;
  final SurveyData _surveyData;
  List<DataGridRow> _koboDataRows = [];
  bool isFirstCall = true;
  int pageNumber = 0;
  int langIndex = 1;

  @override
  List<DataGridRow> get rows => _koboDataRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color? rowColor;
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((e) {
            Widget childWidget = Text(
              e.value.toString(),
              overflow: TextOverflow.ellipsis,
            );
            if (e.columnName == '_validation_status') {
              Widget vIcon = (e.value as ValidationStatus).getIcon();
              childWidget = Row(
                spacing: 5,
                children: [
                  SizedBox(width: 5),
                  vIcon,
                  Text((e.value as ValidationStatus).label.toString()),
                ],
              );
              rowColor = (e.value as ValidationStatus).getColor();
            }
            return Container(alignment: Alignment.center, child: childWidget);
          }).toList(),
      color: rowColor,
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    pageNumber = newPageIndex;

    ResponseData newData = await getIt<KoboService>().fetchFormData(
      uid: _surveyData.uid,
      start: newPageIndex * Constants.limit,
    );
    _koboDataList = newData.results;

    refreshDataGrid();

    return true;
  }

  void buildDataGridRows({int? languageIndex}) {
    setLanguageIndex(languageIndex);
    _koboDataRows =
        _koboDataList.asMap().entries.map((entry) {
          final index = entry.key + 1; // Generate row number
          final item = entry.value;

          final cells =
              _gridColumns.map<DataGridCell<dynamic>>((column) {
                String colName = column.columnName;
                String cellValue = item.data[colName] ?? '';

                if (colName == '#') {
                  return DataGridCell<int>(
                    columnName: '#',
                    value: index + (Constants.limit * pageNumber),
                  );
                } else if (colName == '_validation_status') {
                  return DataGridCell<ValidationStatus>(
                    columnName: '_validation_status',
                    value: item.validationStatus,
                  );
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
                          int choicesItemIndex = _surveyData.choices.indexWhere(
                            (ChoicesItem element) =>
                                element.name == cellValueItem,
                          );
                          choicesItemIndex < 0
                              ? newCellValues.add(cellValueItem)
                              : newCellValues.add(
                                _surveyData.choices[choicesItemIndex].labels
                                    .getIndexOrFirst(langIndex),
                              );
                        }
                        cellValue = newCellValues.join(" ");
                      } else {
                        int choicesItemIndex = _surveyData.choices.indexWhere(
                          (element) => element.name == cellValue,
                        );
                        choicesItemIndex < 0
                            ? cellValue = cellValue
                            : cellValue = _surveyData
                                .choices[choicesItemIndex]
                                .labels
                                .getIndexOrFirst(langIndex);
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

  int setLanguageIndex(int? index) {
    if (index == null) return langIndex;
    langIndex = index;
    return langIndex;
  }

  void refreshDataGrid({
    List<GridColumn>? newColumns,
    List<SubmissionData>? newData,
    int? languageIndex,
  }) {
    if (newColumns != null) _gridColumns = newColumns;
    if (newData != null) _koboDataList = newData;
    buildDataGridRows(languageIndex: languageIndex);
    notifyListeners();
  }
}
