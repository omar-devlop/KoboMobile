import 'package:flutter/material.dart';
import 'package:kobo/data/modules/form_data.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:kobo/featuers/tableScreen/model/kobo_form_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class STableView extends StatefulWidget {
  // final List<SurveyItem> formColumn;
  // final List<SubmissionBasicData> submissionData;
  final SurveyData surveyData;
  const STableView({
    super.key,
    required this.surveyData,
    // required this.formColumn,
    // required this.submissionData,
  });

  @override
  State<STableView> createState() => _STableViewState();
}

class _STableViewState extends State<STableView> {
  late KoboFormDataSource koboDataSource;
  List<SubmissionBasicData> submissionData = <SubmissionBasicData>[];
  List<SurveyItem> formColumns = <SurveyItem>[];
  List<GridColumn> columns = [];

  @override
  void initState() {
    super.initState();
    submissionData = widget.surveyData.data;
    formColumns = widget.surveyData.survey;
    getColumns();
    koboDataSource = KoboFormDataSource(
      formColumns: formColumns,
      koboData: submissionData,
    );
  }

  void getColumns() {
    columns.clear();

    for (var column in formColumns) {
      if (column.type.contains('group') || column.type.contains('repeat')) {
        continue;
      }
      columns.add(
        GridColumn(
          width: columnWidths[column.name] ?? double.nan,
          minimumWidth: 100,
          columnName: column.name,
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(column.name.toString()),
          ),
        ),
      );
      // debugPrint('in |s_table_view| ${dataItem.key}');
    }
    // return columns;
  }

  late Map<String, double> columnWidths = {};
  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        // rowHoverColor: Colors.green.shade50,
        // filterIconColor: Theme.of(context).primaryColor,
        // sortIconColor: Theme.of(context).primaryColor,
      ),

      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        allowFiltering: true,
        allowSorting: true,
        isScrollbarAlwaysShown: true,
        columnWidthMode: ColumnWidthMode.auto,
        showColumnHeaderIconOnHover: true,

        allowColumnsResizing: true,
        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
          setState(() {
            columnWidths[details.column.columnName] = details.width;
          });
          return true;
        },

        source: koboDataSource,
        columns: columns,
      ),
    );
  }
}
