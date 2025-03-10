import 'package:pluto_grid/pluto_grid.dart';

class PlutoTableData {
  List<PlutoColumn> columns;
  List<PlutoRow> rows;
  List<String> languages = [];

  PlutoTableData({
    this.columns = const [],
    this.rows = const [],
    this.languages = const [],
  });
}
