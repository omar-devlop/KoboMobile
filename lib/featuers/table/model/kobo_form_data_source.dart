import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/kobo_utils/safe_index.dart';
import 'package:kobo/core/kobo_utils/validation_status.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/choices_item.dart';
import 'package:kobo/data/modules/response_data.dart';
import 'package:kobo/data/modules/submission_data.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
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
  int _pageNumber = 0;
  int _langIndex = 1;
  bool _isDisposed = false; // Track disposal state

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
              Widget validationIcon = getValidationStatusIcon(
                validationLabel: e.value.toString(),
              );
              childWidget = Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 5,
                children: [
                  SizedBox(width: 5),
                  validationIcon,
                  Expanded(
                    child: Text(
                      e.value.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
              rowColor = getValidationStatusColor(
                validationLabel: e.value.toString(),
              );
            }
            return Container(alignment: Alignment.center, child: childWidget);
          }).toList(),
      color: rowColor,
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _pageNumber = newPageIndex;

    ResponseData newData = await getIt<KoboService>().fetchFormData(
      uid: _surveyData.uid,
      start: newPageIndex * Constants.limit,
    );
    _koboDataList = newData.results;

    refreshDataGrid();

    return true;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void buildDataGridRows({int? languageIndex}) {
    getLanguageIndex(languageIndex);
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
                    value: index + (Constants.limit * _pageNumber),
                  );
                } else if (colName == '_validation_status') {
                  return DataGridCell<String?>(
                    columnName: '_validation_status',
                    value: item.validationStatus?.label,
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
                                    .getIndexOrFirst(_langIndex),
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
                                .getIndexOrFirst(_langIndex);
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

  int getLanguageIndex(int? index) {
    if (index == null) return _langIndex;
    _langIndex = index;
    return _langIndex;
  }

  void refreshDataGrid({
    List<GridColumn>? newColumns,
    List<SubmissionData>? newData,
    int? languageIndex,
  }) {
    if (newColumns != null) _gridColumns = newColumns;
    if (newData != null) _koboDataList = newData;
    buildDataGridRows(languageIndex: languageIndex);
    if (_isDisposed) return;

    notifyListeners();
  }
}
