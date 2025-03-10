import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/logic/cubits/data_table/data_table_cubit.dart';
import 'package:kobo/presentation/widgets/table_view.dart';

class TableDataScreen extends StatelessWidget {
  final KoboForm kForm;
  const TableDataScreen({
    super.key,
    required this.kForm,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataTableCubit, DataTableState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${kForm.name} - Table Data'),
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.language),
                onSelected: (value) {
                  if (value is! int) return;
                  int langIndex = 0;
                  langIndex = value;

                  BlocProvider.of<DataTableCubit>(context)
                      .changeLanguage(langIndex);
                },
                itemBuilder: (BuildContext context) {
                  List<PopupMenuItem> langs = [];
                  state.whenOrNull(
                    success: (data) {
                      for (var i = 0; i < data.languages.length; i++) {
                        langs.add(
                          PopupMenuItem(
                              value: i, child: Text(data.languages[i])),
                        );
                      }
                    },
                  );
                  return langs;
                },
              ),
            ],
          ),
          body: state.when(
            initial: () => LinearProgressIndicator(),
            loading: (msg) => Center(
              child: Column(
                spacing: 20.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Text(msg),
                ],
              ),
            ),
            error: (msg) => Center(
              child: Text(msg),
            ),
            success: (tableData) => TableView(
              columns: tableData.columns,
              rows: tableData.rows,
            ),
          ),
        );
      },
    );
  }
}
