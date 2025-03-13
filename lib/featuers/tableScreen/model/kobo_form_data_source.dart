import 'package:flutter/material.dart';
import 'package:kobo/data/modules/form_data.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KoboFormDataSource extends DataGridSource {
  KoboFormDataSource({
    required List<GridColumn> gridColumns,
    required List<SubmissionBasicData> koboData,
  }) : _gridColumns = gridColumns,
       _koboDataList = koboData {
    buildDataGridRows();
  }

  List<GridColumn> _gridColumns;
  List<SubmissionBasicData> _koboDataList;
  List<DataGridRow> _koboDataRows = [];

  void buildDataGridRows() {
    _koboDataRows =
        _koboDataList.asMap().entries.map((entry) {
          final index = entry.key + 1; // Generate row number
          final item = entry.value;

          final cells =
              _gridColumns.map<DataGridCell<dynamic>>((column) {
                if (column.columnName == '#') {
                  return DataGridCell<int>(columnName: '#', value: index);
                }
                return DataGridCell<String>(
                  columnName: column.columnName,
                  value: item.data[column.columnName] ?? '',
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
  }) {
    if (newColumns != null) _gridColumns = newColumns;
    if (newData != null) _koboDataList = newData;
    buildDataGridRows();
    notifyListeners();
  }
}
