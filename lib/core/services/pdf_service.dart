import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions/general_ext.dart';
import 'package:kobo/core/services/download_manager.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/shared/models/submission_data.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart' as intl;

class PdfService {
  late final pw.Font _cairoFont;
  late final pw.Font _cairoBoldFont;
  late final pw.Font _monoFont;
  late bool _showXML;

  Future<void> initService() async {
    _cairoFont = await PdfGoogleFonts.cairoRegular();
    _cairoBoldFont = await PdfGoogleFonts.cairoBold();
    _monoFont = await PdfGoogleFonts.cutiveMonoRegular();
    _showXML = false;
  }

  List<String> _splitContent(String content) {
    final List<String> sections = [];
    int maxCharsPerPage =
        800; // Change this to the desired number of characters per section 800 default

    if (content.length > maxCharsPerPage) {
      int startIndex = 0;
      while (startIndex < content.length) {
        final int endIndex = startIndex + maxCharsPerPage;
        final int remainingChars = content.length - startIndex;

        final int sectionEndIndex =
            remainingChars >= maxCharsPerPage ? endIndex : content.length;

        final String section = content.substring(startIndex, sectionEndIndex);
        sections.add(section);

        startIndex = sectionEndIndex;
      }
    } else {
      sections.add(content);
    }
    return sections;
  }

  Future<dynamic> createSubmissionPdfFile({
    required KoboFormRepository survey,
    required int submissionIndex,
    required int selectedLangIndex,
    bool? showXml,
    Color? cColor,
  }) async {
    if (showXml != null) _showXML = showXml;

    final svgWidget = await _loadSvgWidget('assets/svg/kobo_logo.svg');
    SubmissionData submissionData =
        survey.responseData.results[submissionIndex];

    final doc = pw.Document();

    List<pw.Widget> widgets = [];

    widgets.add(pw.SizedBox(height: 10));

    for (var entry in submissionData.data.entries) {
      String key = entry.key;
      if (key == '_id') continue;
      dynamic value = entry.value.fieldValue;
      if (key == '_attachments') continue; // handle attachments
      key = survey.getLabel(key);
      value = survey.getLabel(value.toString(), columnName: key);

      for (String section in _splitContent(key.toString())) {
        widgets.add(
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            color:
                cColor != null
                    ? PdfColor.fromInt(cColor.toARGB32())
                    : PdfColors.grey300,
            child: pw.Column(
              children: [
                pw.Container(
                  alignment:
                      intl.Bidi.hasAnyRtl(key)
                          ? pw.Alignment.centerRight
                          : pw.Alignment.centerLeft,
                  child: pw.Text(
                    section,
                    style: pw.TextStyle(fontSize: 10, font: _cairoBoldFont),
                    textDirection:
                        intl.Bidi.hasAnyRtl(key)
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                  ),
                ),
                if (_showXML == true)
                  pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      entry.key.toString(),
                      style: pw.TextStyle(fontSize: 8, font: _monoFont),
                      textDirection: pw.TextDirection.ltr,
                    ),
                  ),
              ],
            ),
          ),
        );
      }

      if (survey.getType(entry.key) == QuestionType.image) {
        String? filePath = await getIt<DownloadManager>().fileExists(
          entry.value.toString().underscored,
        );
        if (filePath == null) continue;
        File file = File(filePath);

        Uint8List imageData = file.readAsBytesSync();
        pw.Image image = pw.Image(
          height: 400,
          width: PdfPageFormat.a4.width / 1.275,
          fit: pw.BoxFit.contain,
          pw.MemoryImage(imageData),
        );

        widgets.add(pw.SizedBox(height: 5));
        widgets.add(
          pw.Container(
            alignment:
                intl.Bidi.hasAnyRtl(value)
                    ? pw.Alignment.centerRight
                    : pw.Alignment.centerLeft,
            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: image,
          ),
        );
        widgets.add(pw.SizedBox(height: 5));
      }

      for (String section in _splitContent(value.toString())) {
        widgets.add(
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            alignment:
                intl.Bidi.hasAnyRtl(section)
                    ? pw.Alignment.centerRight
                    : pw.Alignment.centerLeft,
            child: pw.Text(
              section,
              style: pw.TextStyle(color: PdfColors.grey700, font: _cairoFont),
              textDirection:
                  intl.Bidi.hasAnyRtl(section)
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
            ),
          ),
        );
      }
      if ((_showXML == true) && survey.isSelectionQuestion(entry.key)) {
        widgets.add(
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              entry.value.toString(),
              style: pw.TextStyle(fontSize: 8, font: _monoFont),
              textDirection: pw.TextDirection.ltr,
            ),
          ),
        );
      }

      widgets.add(pw.SizedBox(height: 5));
    }

    try {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerLeft,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey),
                ),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (context.pageNumber == 1)
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 24.0),
                      child: pw.Center(child: svgWidget),
                    ),
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.max,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        survey.form.name,
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: _cairoBoldFont,
                          color:
                              context.pageNumber == 1 ? null : PdfColors.grey,
                        ),
                        textDirection:
                            intl.Bidi.detectRtlDirectionality(survey.form.name)
                                ? pw.TextDirection.rtl
                                : pw.TextDirection.ltr,
                      ),
                      pw.Text(
                        submissionData.id.toString(),
                        style: pw.TextStyle(
                          font: _cairoFont,
                          color:
                              context.pageNumber == 1 ? null : PdfColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          footer: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'This file has been generated by ${Constants.appName}.',
                    style: pw.TextStyle(
                      font: _cairoFont,
                      color: PdfColors.grey,
                    ),
                  ),
                  pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: pw.TextStyle(
                      font: _cairoFont,
                      color: PdfColors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
          build: (context) => widgets,
        ),
      );
      // ignore: non_constant_identifier_names
    } catch (TooManyPagesException) {
      return false;
    }
    return doc.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFilex.open(filePath);
  }

  Future<dynamic> createSubmissionsTablePdfFile({
    required List<SubmissionData> submissions,
    required String formName,
    String? fileName,
    Color? headerColor,
  }) async {
    try {
      final svgWidget = await _loadSvgWidget('assets/svg/kobo_logo.svg');
      final doc = pw.Document();

      // Prepare table data
      final List<List<String>> tableData = [];

      // Add header row
      tableData.add([
        'Index',
        'Submission Time',
        'Validation Status',
        'Meta Instance Name',
        'Has Attachment',
        'Geolocation',
      ]);

      // Add data rows
      for (int i = 0; i < submissions.length; i++) {
        final submission = submissions[i];

        // Format submission time
        String formattedTime = '';
        if (submission.submissionTime.isNotEmpty) {
          try {
            final dateTime = DateTime.parse(submission.submissionTime);
            formattedTime = intl.DateFormat(
              'MMM dd, yyyy - h:mm a',
            ).format(dateTime);
          } catch (e) {
            formattedTime = submission.submissionTime;
          }
        }

        // Format validation status
        String validationStatusText =
            submission.validationStatus?.label ?? 'N/A';

        // Check if has attachments
        String hasAttachment = submission.attachments.isNotEmpty ? 'Yes' : 'No';

        // Format geolocation
        String geolocationText = '';
        if (submission.geolocation.isNotEmpty) {
          try {
            if (submission.geolocation.length >= 2) {
              if (submission.geolocation[0] != null) {
                final lat = submission.geolocation[0].toString();
                final lng = submission.geolocation[1].toString();
                geolocationText = '$lat, $lng';
              }
            } else {
              geolocationText = submission.geolocation.join(', ');
            }
          } catch (e) {
            geolocationText = 'Invalid';
          }
        }

        tableData.add([
          (i + 1).toString(),
          formattedTime,
          validationStatusText,
          submission.metaInstanceName,
          hasAttachment,
          geolocationText,
        ]);
      }

      doc.addPage(
        pw.MultiPage(
          maxPages: (submissions.length / 17).ceil(), // here
          pageFormat:
              PdfPageFormat
                  .a4
                  .landscape, // Use landscape for better table display
          margin: const pw.EdgeInsets.all(20),
          header: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerLeft,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey),
                ),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (context.pageNumber == 1)
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 24.0),
                      child: pw.Center(child: svgWidget),
                    ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        formName,
                        style: pw.TextStyle(
                          fontSize: 16,
                          font: _cairoBoldFont,
                          color:
                              context.pageNumber == 1 ? null : PdfColors.grey,
                        ),
                        textDirection:
                            intl.Bidi.detectRtlDirectionality(formName)
                                ? pw.TextDirection.rtl
                                : pw.TextDirection.ltr,
                      ),
                      pw.Text(
                        'Submissions Report',
                        style: pw.TextStyle(
                          fontSize: 14,
                          font: _cairoFont,
                          color:
                              context.pageNumber == 1 ? null : PdfColors.grey,
                        ),
                      ),
                    ],
                  ),
                  if (context.pageNumber == 1)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 10),
                      child: pw.Text(
                        'Total Submissions: ${submissions.length}',
                        style: pw.TextStyle(fontSize: 12, font: _cairoFont),
                      ),
                    ),
                ],
              ),
            );
          },
          footer: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Generated by ${Constants.appName} on ${intl.DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(
                      font: _cairoFont,
                      color: PdfColors.grey,
                      fontSize: 8,
                    ),
                  ),
                  pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: pw.TextStyle(
                      font: _cairoFont,
                      color: PdfColors.grey,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            );
          },
          build:
              (context) => [
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey300,
                    width: 0.5,
                  ),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(50), // Index
                    1: const pw.FixedColumnWidth(120), // Submission Time
                    2: const pw.FixedColumnWidth(100), // Validation Status
                    3: const pw.FlexColumnWidth(2), // Meta Instance Name
                    4: const pw.FixedColumnWidth(80), // Has Attachment
                    5: const pw.FlexColumnWidth(1.5), // Geolocation
                  },
                  children:
                      tableData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final row = entry.value;
                        final isHeader = index == 0;
                        final isOddRow = index % 2 == 1;

                        return pw.TableRow(
                          decoration:
                              isHeader
                                  ? pw.BoxDecoration(
                                    color:
                                        headerColor != null
                                            ? PdfColor.fromInt(
                                              headerColor.toARGB32(),
                                            )
                                            : PdfColors.blue,
                                  )
                                  : isOddRow
                                  ? const pw.BoxDecoration(
                                    color: PdfColors.grey50,
                                  )
                                  : null,
                          children:
                              row.asMap().entries.map((cellEntry) {
                                final cellIndex = cellEntry.key;
                                final cellText = cellEntry.value;

                                // Determine alignment based on column and text direction
                                pw.Alignment alignment;
                                switch (cellIndex) {
                                  case 0: // Index
                                  case 2: // Validation Status
                                  case 4: // Has Attachment
                                    alignment = pw.Alignment.center;
                                    break;
                                  case 1: // Submission Time
                                  case 5: // Geolocation
                                    alignment = pw.Alignment.centerLeft;
                                    break;
                                  case 3: // Meta Instance Name
                                    alignment =
                                        intl.Bidi.detectRtlDirectionality(
                                              cellText[0],
                                            )
                                            ? pw.Alignment.centerRight
                                            : pw.Alignment.centerLeft;
                                    break;
                                  default:
                                    alignment = pw.Alignment.centerLeft;
                                }

                                return pw.Container(
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(4),
                                  alignment: alignment,
                                  child: pw.Text(
                                    cellText,
                                    style: pw.TextStyle(
                                      font:
                                          isHeader
                                              ? _cairoBoldFont
                                              : _cairoFont,
                                      fontSize: isHeader ? 10 : 9,
                                      color:
                                          isHeader
                                              ? PdfColors.white
                                              : PdfColors.black,
                                    ),
                                    textDirection:
                                        intl.Bidi.detectRtlDirectionality(
                                              cellText,
                                            )
                                            ? pw.TextDirection.rtl
                                            : pw.TextDirection.ltr,
                                    maxLines: 2,
                                    overflow: pw.TextOverflow.clip,
                                  ),
                                );
                              }).toList(),
                        );
                      }).toList(),
                ),
              ],
        ),
      );

      return doc.save();
    } catch (e, stackTrace) {
      debugPrint('PDF creation failed: $e');
      debugPrint('PDF creation failed: $stackTrace');
      return false;
    }
  }

  Future<pw.Widget> _loadSvgWidget(String assetPath) async {
    final svgString = await rootBundle.loadString(assetPath);
    final svgImage = pw.SvgImage(svg: svgString);
    return svgImage;
  }
}
