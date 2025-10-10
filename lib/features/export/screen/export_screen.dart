import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobo/core/cubits/kobo_form/k_form_cubit.dart';
import 'package:kobo/core/helpers/extensions/app_theme.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';

class ExportScreen extends StatefulWidget {
  final KoboForm kForm;
  const ExportScreen({super.key, required this.kForm});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  int _exportType = 0;
  int? _progress;
  final Map<int, String> _exportTypeMap = {0: 'pdf', 1: 'excel'};
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          _startController.text = "${picked.toLocal()}".split(' ')[0];
        } else {
          endDate = picked;
          _endController.text = "${picked.toLocal()}".split(' ')[0];
        }
      });
      // بعد التغيير أعد التحقق
      _formKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingButton(String msg) {
      return FilledButton.icon(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(context.colors.onSecondary),
          backgroundColor: WidgetStatePropertyAll(context.colors.secondary),
        ),
        onPressed: null,
        label: Text(context.tr(msg)),
        icon: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            color: context.colors.onPrimary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(widget.kForm.name, overflow: TextOverflow.ellipsis),
          contentPadding: EdgeInsets.zero,
          subtitle: Text(context.tr('export'), overflow: TextOverflow.ellipsis),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),

          children: [
            const SizedBox(height: 32),
            Text(
              context.tr('submissionDateRange'),
              style: context.texts.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _startController,
              readOnly: true,
              onTap: () => _pickDate(isStart: true),
              validator: (_) {
                if (startDate != null && endDate != null) {
                  if (startDate!.isAfter(endDate!)) {
                    return context.tr('startBeforeEnd');
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.colors.outlineVariant),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                suffixIcon:
                    startDate == null
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed:
                              () => setState(() {
                                startDate = null;
                                _startController.clear();
                              }),
                        ),
                prefixIcon: const Icon(Icons.date_range),
                hintText:
                    startDate == null
                        ? context.tr('startDate')
                        : "${startDate!.toLocal()}".split(' ')[0],
                filled: true,
                fillColor: context.colors.onInverseSurface,
                labelText: "Start Date",
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _endController,
              readOnly: true,
              onTap: () => _pickDate(isStart: false),
              validator: (_) {
                if (endDate != null && startDate != null) {
                  if (endDate!.isBefore(startDate!)) {
                    return context.tr('endAfterStart');
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.colors.outlineVariant),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                suffixIcon:
                    endDate == null
                        ? null
                        : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed:
                              () => setState(() {
                                endDate = null;
                                _endController.clear();
                              }),
                        ),
                prefixIcon: const Icon(Icons.date_range),
                hintText:
                    endDate == null
                        ? context.tr('endDate')
                        : "${endDate!.toLocal()}".split(' ')[0],
                filled: true,
                fillColor: context.colors.onInverseSurface,
                labelText: "End Date",
              ),
            ),

            const SizedBox(height: 32),
            Text(
              context.tr('exportType'),
              style: context.texts.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            RadioGroup<int>(
              groupValue: _exportType,
              onChanged: (int? value) {
                setState(() {
                  _exportType = value!;
                });
              },
              child: Column(
                children: [
                  for (var entry in _exportTypeMap.entries)
                    RadioListTile(
                      value: entry.key,
                      title: Text(context.tr(entry.value)),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            BlocBuilder<KFormCubit, KFormState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: (msg) => loadingButton(msg),
                  orElse:
                      () => FilledButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          if (!mounted) return;
                          setState(() {
                            _progress = 0;
                          });

                          // تحويل التواريخ إلى صيغة ISO 8601
                          String? start = startDate?.toIso8601String();

                          String? end;
                          if (endDate != null) {
                            // ضبط نهاية اليوم
                            final endOfDay = DateTime(
                              endDate!.year,
                              endDate!.month,
                              endDate!.day,
                              23,
                              59,
                              59,
                            );
                            end = endOfDay.toIso8601String();
                          }

                          // إعداد query إضافي مع إضافة القيم غير الفارغة فقط
                          Map<String, dynamic>? additionalQuery;

                          final submissionTime = <String, String>{};

                          if (start != null) {
                            submissionTime["\$gte"] = start;
                          }
                          if (end != null) {
                            submissionTime["\$lte"] = end;
                          }

                          if (submissionTime.isNotEmpty) {
                            additionalQuery = {
                              "_submission_time": submissionTime,
                            };
                          }

                          bool exported = await context
                              .read<KFormCubit>()
                              .export(additionalQuery: additionalQuery);
                          if (!exported) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.tr('errorGeneral')),
                              ),
                            );
                          } else {
                            if (!mounted) return;
                            setState(() {
                              _progress = null;
                            });
                          }
                        },
                        child: Text(context.tr('export')),
                      ),
                );
              },
            ),

            const SizedBox(height: 16),
            if (_progress != null) ...[
              Text(
                context.tr('exportingData'),
                style: context.texts.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
              // const SizedBox(height: 8),
              // Text(
              //   context.tr('complete', args: ['$_progress%']),
              //   style: context.texts.bodyMedium?.copyWith(
              //     color: context.colors.onSurface,
              //   ),
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
