import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/kobo_utils/safe_index.dart';
import 'package:kobo/data/modules/survey_data.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:kobo/featuers/table/model/kobo_form_data_source.dart';
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

  GridColumn koboGridColumn({
    required String columnName,
    String? columnLabel,
    double? width,
    double minimumWidth = 100,
  }) {
    return GridColumn(
      width: columnWidths[columnName] ?? width ?? double.nan,
      minimumWidth: minimumWidth,
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
    columns.add(
      koboGridColumn(columnName: '#', columnLabel: '#', minimumWidth: 75),
    );
    columns.add(
      koboGridColumn(
        columnName: '_validation_status',
        columnLabel: 'Validation',
      ),
    );
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
      String columnLabel = '';
      if (columnName == '_validation_status') {
        columnLabel = 'Validation';
      } else {
        SurveyItem? formColumn =
            formColumns
                .where((element) => element.name == columnName)
                .firstOrNull;
        columnLabel =
            formColumn == null
                ? columnName
                : formColumn.labels.getIndexOrFirst(selectedLangIndex);
      }

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
          int columnLabelIndex = formColumns.indexWhere(
            (element) => element.name == columnName,
          );
          String columnLabel = '';
          if (columnName == '_validation_status') {
            columnLabel = 'Validation';
          } else {
            columnLabel =
                columnLabelIndex < 0
                    ? columnName
                    : formColumns[columnLabelIndex].labels.getIndexOrFirst(
                      selectedLangIndex,
                    );
          }
          columnWidths[columnName] = details.width;
          if (!mounted) return false;

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
    double pageCount =
        (surveyData.deploymentSubmissionCount / _rowsPerPage).ceil().toDouble();
    pageCount = pageCount < 1 ? 1 : pageCount;
    return SfDataPagerTheme(
      data: SfDataPagerThemeData(
        selectedItemColor: Theme.of(context).primaryColor,
      ),
      child: SfDataPager(
        delegate: koboDataSource,
        availableRowsPerPage: const <int>[30, 50, 100, 200, 500],

        pageCount: pageCount,

        // onRowsPerPageChanged: (int? rowsPerPage) {
        // if (!mounted) return;
        //   setState(() {
        //     _rowsPerPage = rowsPerPage!;
        //   });
        // },
        onPageNavigationStart: (int pageIndex) {
          if (!mounted) return;
          setState(() {
            showLoadingIndicator = true;
          });
        },
        onPageNavigationEnd: (int pageIndex) {
          if (!mounted) return;
          setState(() {
            showLoadingIndicator = false;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    koboDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${surveyData.formName} - S Table Data'),
        actions: [
          PopupMenuButton<int>(
            initialValue: selectedLangIndex,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.filter_list_off),
                      SizedBox(width: 10),
                      Text('Clear Sort'),
                    ],
                  ),
                  onTap: () {
                    if (koboDataSource.sortedColumns.isEmpty) return;
                    koboDataSource.sortedColumns.clear();
                    koboDataSource.notifyListeners();
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt_off_outlined),
                      SizedBox(width: 10),
                      Text('Clear Filters'),
                    ],
                  ),
                  onTap: () {
                    if (koboDataSource.filterConditions.isEmpty) return;
                    koboDataSource.clearFilters();
                    koboDataSource.notifyListeners();
                  },
                ),

                PopupMenuDivider(),

                ...List<PopupMenuEntry<int>>.generate(
                  languages.length,
                  (i) => CheckedPopupMenuItem<int>(
                    value: i,
                    checked: selectedLangIndex == i,
                    child: Text(languages.getIndexOrFirst(i)),
                  ),
                ),
              ];
            },
            onSelected: (int item) {
              if (!mounted) return;
              if (item == selectedLangIndex) return;
              selectedLangIndex = item;

              setState(() {});
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
