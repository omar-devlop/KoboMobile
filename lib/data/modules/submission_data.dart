import 'package:kobo/data/modules/validation_status.dart';

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
  late Map<String, String> data;

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
    required this.data,
  });

  SubmissionData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    formhubUuid = json['formhub/uuid'] ?? "";
    version = json['__version__'] ?? "";
    metaInstanceID = json['meta/instanceID'] ?? "";
    metaInstanceName = json['meta/instanceName'] ?? "instanceName: n/a";
    xformIdString = json['_xform_id_string'] ?? "";
    uuid = json['_uuid'] ?? "";
    status = json['_status'] ?? "";
    submissionTime = json['_submission_time'] ?? "";
    submittedBy = json['_submitted_by'] ?? "";
    validationStatus =
        json['_validation_status'] != null
            ? ValidationStatus.fromJson(json['_validation_status'])
            : null;
    data = {};
    json.forEach(
      (key, value) => data.addAll({
        key.split('/').last:
            value
                .toString(), // Split key to remove the group path name and get the key name only
      }),
    );
  }
}
