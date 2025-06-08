import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions/question_type_ext.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/core/shared/widget/action_spacing.dart';
import 'package:kobo/core/shared/widget/language_selector.dart';
import 'package:kobo/features/table/model/kobo_form_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class TableView extends StatefulWidget {
  final KoboFormRepository survey;
  const TableView({super.key, required this.survey});

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  late KoboFormDataSource koboDataSource;
  late Map<String, double> columnWidths = {};
  late KoboFormRepository survey;
  List<GridColumn> columns = <GridColumn>[];
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
    for (SurveyItem column in survey.questions) {
      if (column.type.isGroupOrRepeat) {
        continue;
      }
      columns.add(
        koboGridColumn(
          columnName: column.name,
          columnLabel: survey.getLabel(column.name),
        ),
      );
    }
    return columns;
  }

  void updateColumns() {
    for (int i = 0; i < columns.length; i++) {
      String columnName = columns[i].columnName;
      String columnLabel = survey.getLabel(columnName);

      columns[i] = koboGridColumn(
        columnName: columnName,
        columnLabel: columnLabel,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    survey = widget.survey;
    columns = getColumns();

    koboDataSource = KoboFormDataSource(gridColumns: columns, survey: survey);
  }

  Widget _buildDataGrid() {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        filterIconColor: Theme.of(context).primaryColor,
        sortIconColor: Theme.of(context).primaryColor,
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

          columnWidths[columnName] = details.width;
          if (!mounted) return false;

          columns[columnIndex] = koboGridColumn(
            columnName: columnName,
            columnLabel: survey.getLabel(columnName),
          );
          setState(() {});
          return true;
        },

        allowColumnsDragging: true,
        onColumnDragging: (DataGridColumnDragDetails details) {
          if (details.action == DataGridColumnDragAction.dropped &&
              details.to != null) {
            final GridColumn rearrangeColumn = columns[details.from];
            columns.removeAt(details.from);
            columns.insert(details.to!, rearrangeColumn);
            koboDataSource.refreshDataGrid();
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
        (survey.form.deploymentSubmissionCount ?? 0 / _rowsPerPage)
            .ceil()
            .toDouble();
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
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          subtitle: Text(survey.form.name, overflow: TextOverflow.ellipsis),
          contentPadding: EdgeInsets.zero,
          title: Text(context.tr('table'), overflow: TextOverflow.ellipsis),
        ),
        actions: [
          SurveyLanguageSelector(
            survey: survey,
            selectedLangIndex: selectedLangIndex,
            extraItems: [
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.filter_list_off),
                    const SizedBox(width: 16.0),
                    Text(context.tr('clearSort')),
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
                    const Icon(Icons.filter_alt_off_outlined),
                    const SizedBox(width: 16.0),
                    Text(context.tr('clearFilters')),
                  ],
                ),
                onTap: () {
                  if (koboDataSource.filterConditions.isEmpty) return;
                  koboDataSource.clearFilters();
                  koboDataSource.notifyListeners();
                },
              ),
            ],
            onSelected: (val) {
              if (!mounted) return;
              if (val == selectedLangIndex) return;
              selectedLangIndex = val;

              setState(() {
                survey.languageIndex = val;
              });
              updateColumns();
              koboDataSource.refreshDataGrid(newColumns: columns);
            },
          ),
          const ActionsSpacing(),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildDataGrid(),
                if (showLoadingIndicator)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      color: Colors.black12,
                      child: const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
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
