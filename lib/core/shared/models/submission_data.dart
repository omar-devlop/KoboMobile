import 'package:easy_localization/easy_localization.dart';
import 'package:kobo/core/shared/models/attachment.dart';
import 'package:kobo/core/shared/models/kobo_basic_form_fields.dart';
import 'package:kobo/core/shared/models/submission_field.dart';
import 'package:kobo/core/shared/models/validation_status.dart';

class SubmissionData {
  late int id;
  late String formhubUuid;
  late String version;
  late String metaInstanceID;
  late String metaInstanceName;
  late String xformIdString;
  late String uuid;
  late String status;
  late String submissionTime;
  late String submittedBy;
  ValidationStatus? validationStatus;
  late List<Attachment> attachments;
  late String metaRootUuid;
  late String metaDeprecatedID;
  late List<dynamic> geolocation;
  late List<dynamic> tags;
  late List<dynamic> notes;

  late Map<String, SubmissionField> data;

  SubmissionData({
    required this.id,
    required this.formhubUuid,
    required this.version,
    required this.metaInstanceID,
    required this.metaInstanceName,
    required this.xformIdString,
    required this.uuid,
    required this.status,
    required this.submissionTime,
    required this.submittedBy,
    this.validationStatus,
    required this.attachments,
    required this.metaRootUuid,
    required this.metaDeprecatedID,
    required this.geolocation,
    required this.tags,
    required this.notes,

    required this.data,
  });

  SubmissionData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    formhubUuid = json['formhub/uuid'] ?? "";
    version = json['__version__'].toString();
    metaInstanceID = json['meta/instanceID'] ?? "";
    metaInstanceName = json['meta/instanceName'] ?? tr('instanceNameNa');
    xformIdString = json['_xform_id_string'] ?? "";
    uuid = json['_uuid'] ?? "";
    status = json['_status'] ?? "";
    submissionTime =
        json['_submission_time'] != null
            ? json['_submission_time'] + 'Z'
            : ""; // Add "Z" to treat the time as UTC (Kobo API returns UTC without timezone info)

    submittedBy = json['_submitted_by'] ?? "";
    validationStatus =
        json['_validation_status'] != null
            ? ValidationStatus.fromJson(json['_validation_status'])
            : null;
    attachments =
        json['_attachments'] == null
            ? []
            : json['_attachments']
                .map<Attachment>((item) => Attachment.fromJson(item))
                .toList();

    metaRootUuid = json['meta/rootUuid'] ?? "";
    metaDeprecatedID = json['meta/deprecatedID'] ?? "";
    geolocation = json['_geolocation'] ?? [];
    tags = json['_tags'] ?? [];
    notes = json['_notes'] ?? [];

    data = {};
    json.forEach((key, value) {
      if (!basicFormFields.contains(key)) {
        // print('$key (${value.runtimeType}): $value');
        final keyName = key.split('/').last;
        SubmissionField field = SubmissionField(value, key);
        // print('$keyName : ${field.fieldType}');
        data.addAll({keyName: field});
      }
    });
  }
}
