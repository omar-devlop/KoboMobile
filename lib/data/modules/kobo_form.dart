class KoboForm {
  String? dateCreated;
  String? dateModified;
  String? dateDeployed;
  late String ownerUsername;
  late String uid;
  String? kind;
  late String name;
  String? assetType;
  String? versionId;
  late bool hasDeployment;
  bool? deploymentActive;
  late int deploymentSubmissionCount;
  String? deploymentStatus;
  String? status;

  KoboForm({
    this.dateCreated,
    this.dateModified,
    this.dateDeployed,
    required this.ownerUsername,
    required this.uid,
    this.kind,
    required this.name,
    this.assetType,
    this.versionId,
    required this.hasDeployment,
    this.deploymentActive,
    required this.deploymentSubmissionCount,
    this.deploymentStatus,
    this.status,
  });

  KoboForm.fromJson(Map<String, dynamic> json) {
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    dateDeployed = json['date_deployed'];
    ownerUsername = json['owner__username'] ?? '';
    uid = json['uid'].toString();
    kind = json['kind'];
    name = json['name'].toString();
    assetType = json['asset_type'];
    versionId = json['version_id'];
    hasDeployment = json['has_deployment'] ?? false;
    deploymentActive = json['deployment__active'];
    deploymentSubmissionCount = json['deployment__submission_count'] ?? 0;
    deploymentStatus = json['deployment_status'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date_created'] = dateCreated;
    data['date_modified'] = dateModified;
    data['date_deployed'] = dateDeployed;
    data['owner__username'] = ownerUsername;
    data['uid'] = uid;
    data['kind'] = kind;
    data['name'] = name;
    data['asset_type'] = assetType;
    data['version_id'] = versionId;
    data['has_deployment'] = hasDeployment;
    data['deployment__active'] = deploymentActive;
    data['deployment__submission_count'] = deploymentSubmissionCount;
    data['deployment_status'] = deploymentStatus;
    data['status'] = status;
    return data;
  }
}
