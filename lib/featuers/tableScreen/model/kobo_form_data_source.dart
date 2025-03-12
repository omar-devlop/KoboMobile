import 'package:flutter/material.dart';
import 'package:kobo/data/modules/form_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class KoboFormDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  KoboFormDataSource({
    required List<SurveyItem> formColumns,
    required List<SubmissionBasicData> koboData,
  }) {
    List<DataGridCell<dynamic>> getCells(SubmissionBasicData item) {
      List<DataGridCell<dynamic>> cells = [];
      for (var column in formColumns) {
        if (column.type.contains('group') || column.type.contains('repeat')) {
          continue;
        }
        cells.add(
          DataGridCell<String>(
            columnName: column.name,
            value: item.data[column.name] ?? '',
          ),
        );
      }

      return cells;
    }

    _employeeData =
        koboData
            .map<DataGridRow>((item) => DataGridRow(cells: getCells(item)))
            .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // final int index = effectiveRows.indexOf(row);
    return DataGridRowAdapter(
      // color: index % 2 != 0 ? Colors.black12.withAlpha(10) : Colors.transparent,
      cells:
          row.getCells().map<Widget>((e) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8.0),
              child: Text(e.value.toString(), overflow: TextOverflow.ellipsis),
            );
          }).toList(),
    );
  }
}
