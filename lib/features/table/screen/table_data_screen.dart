import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/features/table/bloc/data_table_cubit.dart';
import 'package:kobo/features/table/widget/table_view.dart';

class TableDataScreen extends StatelessWidget {
  final KoboForm kForm;
  const TableDataScreen({super.key, required this.kForm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataTableCubit, DataTableState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.whenOrNull(
            initial: () => AppBar(),
            loading:
                (_) => AppBar(
                  title: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(kForm.name, overflow: TextOverflow.ellipsis),
                    contentPadding: EdgeInsets.zero,
                    subtitle: Text(
                      context.tr('table'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            error: (_) => AppBar(),
          ),
          body: state.when(
            initial: () => const LinearProgressIndicator(),
            loading:
                (msg) => Center(
                  child: Column(
                    spacing: 20.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [const CircularProgressIndicator(), Text(msg)],
                  ),
                ),
            error: (msg) => Center(child: Text(msg)),
            success: (data) => TableView(survey: data),
          ),
        );
      },
    );
  }
}
