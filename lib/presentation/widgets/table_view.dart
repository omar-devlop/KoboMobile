import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableView extends StatelessWidget {
  final List<PlutoColumn> columns;
  final List<PlutoRow> rows;

  const TableView({
    super.key,
    required this.columns,
    this.rows = const [],
  });

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      configuration: PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          rowColor: Colors.transparent,
          gridBackgroundColor: Colors.transparent,
          // borderColor: Colors.black12,
          // oddRowColor: Colors.grey.shade100.withAlpha(150),
          evenRowColor: Colors.grey.shade50.withAlpha(150),
          rowHeight: 28,
          columnHeight: 28,
          cellTextStyle: const TextStyle(color: Colors.black, fontSize: 10),
          // columnTextStyle: const TextStyle(fontSize: 12),
          // defaultCellPadding:
          //     const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          // defaultColumnTitlePadding:
          //     const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        ),
      ),
      onLoaded: (PlutoGridOnLoadedEvent event) {
        // pState = event.stateManager;
      },
    );
  }
}
