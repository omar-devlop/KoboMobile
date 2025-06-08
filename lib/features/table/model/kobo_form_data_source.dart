import 'package:flutter/material.dart';
import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions/question_type_ext.dart';
import 'package:kobo/core/kobo_utils/validation_status_tool.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KoboFormDataSource extends DataGridSource {
  KoboFormDataSource({
    required List<GridColumn> gridColumns,
    required KoboFormRepository survey,
  }) : _gridColumns = gridColumns,
       _survey = survey {
    buildDataGridRows();
  }

  List<GridColumn> _gridColumns;
  final KoboFormRepository _survey;
  List<DataGridRow> _koboDataRows = [];
  int _pageNumber = 0;
  bool _isDisposed = false;

  @override
  List<DataGridRow> get rows => _koboDataRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color? rowColor;
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((cell) {
            return Container(
              alignment: Alignment.center,
              child: _buildCellWidget(
                cell,
                onRowColorChanged: (color) {
                  rowColor = color;
                },
              ),
            );
          }).toList(),
      color: rowColor,
    );
  }

  Widget _buildCellWidget(
    DataGridCell cell, {
    void Function(Color)? onRowColorChanged,
  }) {
    if (cell.columnName == '_validation_status') {
      final validationIcon = getValidationStatusIcon(
        validationLabel: cell.value.toString(),
      );

      onRowColorChanged?.call(
        getValidationStatusColor(validationLabel: cell.value.toString()) ??
            Colors.transparent,
      );
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(width: 5),
          validationIcon,
          Expanded(
            child: Text(cell.value.toString(), overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    }
    return Text(cell.value.toString(), overflow: TextOverflow.ellipsis);
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _pageNumber = newPageIndex;
    await _survey.fetchData(pageIndex: newPageIndex);
    refreshDataGrid();
    return true;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void buildDataGridRows() {
    _koboDataRows =
        _survey.responseData.results.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          final cells =
              _gridColumns.map<DataGridCell<dynamic>>((column) {
                final colName = column.columnName;
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
                String cellValue = '';
                if (item.data[colName].runtimeType != String) {
                  if (item.data[colName] != null) {
                    cellValue = item.data[colName]!.fieldValue.toString();
                  }
                } else {
                  cellValue = item.data[colName]?.fieldValue ?? '';
                }

                if (cellValue.isNotEmpty) {
                  final surveyItemIndex = _survey.questions.indexWhere(
                    (q) => q.name == colName,
                  );
                  if (surveyItemIndex >= 0) {
                    final surveyItem = _survey.questions[surveyItemIndex];
                    if (surveyItem.type.isSelection) {
                      if (surveyItem.type == QuestionType.selectMultiple ||
                          surveyItem.type ==
                              QuestionType.selectMultipleFromFile) {
                        cellValue = _survey.getMultiLabel(cellValue);
                      } else {
                        cellValue = _survey.getLabel(cellValue);
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

  void refreshDataGrid({
    List<GridColumn>? newColumns,
    List<SubmissionData>? newData,
  }) {
    if (newColumns != null) _gridColumns = newColumns;
    if (newData != null) _survey.responseData.results = newData;

    buildDataGridRows();
    if (_isDisposed) return;
    notifyListeners();
  }
}
