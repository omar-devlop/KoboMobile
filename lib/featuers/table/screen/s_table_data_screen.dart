import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/data/modules/kobo_form.dart';
import 'package:kobo/featuers/table/bloc/s_data_table_cubit.dart';
import 'package:kobo/featuers/table/widget/s_table_view.dart';

class STableDataScreen extends StatelessWidget {
  final KoboForm kForm;
  const STableDataScreen({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SDataTableCubit, SDataTableState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.whenOrNull(
            initial: () => AppBar(),
            loading:
                (_) => AppBar(title: Text(' ${kForm.name} - S Table Data')),
            error: (_) => AppBar(),
          ),
          body: state.when(
            initial: () => LinearProgressIndicator(),
            loading:
                (msg) => Center(
                  child: Column(
                    spacing: 20.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [CircularProgressIndicator(), Text(msg)],
                  ),
                ),
            error: (msg) => Center(child: Text(msg)),
            success: (tableData) => STableView(surveyData: tableData),
          ),
        );
      },
    );
  }
}
