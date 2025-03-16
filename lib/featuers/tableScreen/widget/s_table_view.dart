import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/kobo_utils/safe_index.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:kobo/featuers/tableScreen/model/kobo_form_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class STableView extends StatefulWidget {
  final SurveyData surveyData;
  const STableView({super.key, required this.surveyData});

  @override
  State<STableView> createState() => _STableViewState();
}

class _STableViewState extends State<STableView> {
  late KoboFormDataSource koboDataSource;
  late Map<String, double> columnWidths = {};
  late SurveyData surveyData;
  List<SurveyItem> formColumns = <SurveyItem>[];
  List<GridColumn> columns = <GridColumn>[];
  List<String> languages = <String>[];
  int selectedLangIndex = 1;
  final int _rowsPerPage = Constants.limit;
  static const double _dataPagerHeight = 60;
  bool showLoadingIndicator = true;

  // Kobo Grid Column
  GridColumn koboGridColumn({required String columnName, String? columnLabel}) {
    return GridColumn(
      width: columnWidths[columnName] ?? double.nan,
      minimumWidth: 100,
      columnName: columnName,
      label: Container(
        // padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Text(columnLabel ?? columnName),
      ),
    );
  }

  List<GridColumn> getColumns() {
    columns.clear();
    columns.add(koboGridColumn(columnName: '#', columnLabel: '#'));
    for (var column in formColumns) {
      if (column.type.contains('group') || column.type.contains('repeat')) {
        continue;
      }
      columns.add(
        koboGridColumn(
          columnName: column.name,
          columnLabel: column.labels.getIndexOrFirst(selectedLangIndex),
        ),
      );
    }
    return columns;
  }

  void updateColumns() {
    for (int i = 0; i < columns.length; i++) {
      String columnName = columns[i].columnName;
      SurveyItem? formColumn =
          formColumns
              .where((element) => element.name == columnName)
              .firstOrNull;
      String columnLabel =
          formColumn == null
              ? columnName
              : formColumn.labels.getIndexOrFirst(selectedLangIndex);

      GridColumn newCol = koboGridColumn(
        columnName: columnName,
        columnLabel: columnLabel,
      );
      columns.removeAt(i);
      columns.insert(i, newCol);
    }
  }

  @override
  void initState() {
    super.initState();
    surveyData = widget.surveyData;
    // submissionData = surveyData.data!.results;
    formColumns = surveyData.survey;
    languages = surveyData.languages;
    columns = getColumns();
    koboDataSource = KoboFormDataSource(
      gridColumns: columns,
      surveyData: surveyData,
    );
  }

  Widget _buildDataGrid() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        // rowHoverColor: Colors.green.shade50,
        // filterIconColor: theme.primaryColor,
        // sortIconColor: theme.primaryColor,
      ),

      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        allowFiltering: true,
        allowSorting: true,
        sortingGestureType: SortingGestureType.doubleTap,

        isScrollbarAlwaysShown: true,
        columnWidthMode: ColumnWidthMode.auto,
        showColumnHeaderIconOnHover: true,
        rowHeight: 30,
        headerRowHeight: 40,

        rowsPerPage: _rowsPerPage,

        allowColumnsResizing: true,
        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
          int columnIndex = details.columnIndex;
          String columnName = details.column.columnName;
          String columnLabel = formColumns
              .firstWhere((element) => element.name == columnName)
              .labels
              .getIndexOrFirst(selectedLangIndex);
          columnWidths[columnName] = details.width;
          setState(() {
            columns[columnIndex] = koboGridColumn(
              columnName: columnName,
              columnLabel: columnLabel,
            );
          });
          return true;
        },

        allowColumnsDragging: true,
        onColumnDragging: (DataGridColumnDragDetails details) {
          if (details.action == DataGridColumnDragAction.dropped &&
              details.to != null) {
            final GridColumn rearrangeColumn = columns[details.from];
            columns.removeAt(details.from);
            columns.insert(details.to!, rearrangeColumn);
            koboDataSource.refreshDataGrid(languageIndex: selectedLangIndex);
          }
          return true;
        },

        
        // onQueryRowHeight: (details) {
        //   return details.getIntrinsicRowHeight(details.rowIndex);
        // },
        columns: columns,
        source: koboDataSource,
      ),
    );
  }

  Widget _buildDataPager() {
    // debugPrint((surveyData.data!.count / _rowsPerPage).ceil().toString());
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
        selectedItemColor: Theme.of(context).primaryColor,
      ),
      child: SfDataPager(
        delegate: koboDataSource,
        availableRowsPerPage: const <int>[30, 50, 100, 200, 500],

        // pageCount: (surveyData.data!.count / _rowsPerPage).ceil().toDouble(),
        pageCount:
            (surveyData.deploymentSubmissionCount / _rowsPerPage)
                .ceil()
                .toDouble(),

        // onRowsPerPageChanged: (int? rowsPerPage) {
        //   setState(() {
        //     _rowsPerPage = rowsPerPage!;
        //   });
        // },
        onPageNavigationStart: (int pageIndex) {
          setState(() {
            showLoadingIndicator = true;
          });
        },
        onPageNavigationEnd: (int pageIndex) {
          setState(() {
            showLoadingIndicator = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${surveyData.formName} - S Table Data'),
        actions: [
          TextButton.icon(
            onPressed: () {
              if (koboDataSource.sortedColumns.isEmpty) return;
              koboDataSource.sortedColumns.clear();
              koboDataSource.notifyListeners();
            },
            label: Text('Clear Sort'),
            icon: Icon(Icons.filter_list_off),
          ),
          TextButton.icon(
            onPressed: () {
              if (koboDataSource.filterConditions.isEmpty) return;
              koboDataSource.clearFilters();
              koboDataSource.notifyListeners();
            },
            label: Text('Clear Filters'),
            icon: Icon(Icons.filter_alt_off_outlined),
          ),
          SizedBox(width: 10),
          PopupMenuButton<int>(
            icon: Icon(Icons.translate),
            initialValue: selectedLangIndex,
            itemBuilder:
                (BuildContext context) => List<PopupMenuEntry<int>>.generate(
                  languages.length,
                  (i) => CheckedPopupMenuItem<int>(
                    value: i,
                    checked: selectedLangIndex == i,
                    child: Text(languages.getIndexOrFirst(i)),
                  ),
                ),
            onSelected: (int item) {
              if (item == selectedLangIndex) return;
              setState(() {
                selectedLangIndex = item;
              });
              updateColumns();
              koboDataSource.refreshDataGrid(
                newColumns: columns,
                languageIndex: selectedLangIndex,
              );
            },
          ),
          SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildDataGrid(),
                if (showLoadingIndicator)
                  Container(
                    color: Colors.black12,
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: _dataPagerHeight, child: _buildDataPager()),
        ],
      ),
    );
  }
}
