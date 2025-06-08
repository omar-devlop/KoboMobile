class KoboForm {
  // --- your original fields ---
  late String dateCreated;
  late String dateModified;
  late String dateDeployed;
  late String ownerUsername;
  late String uid;
  String? kind;
  late String name;
  String? assetType;
  String? versionId;
  late bool hasDeployment;
  late bool deploymentActive;
  int? deploymentSubmissionCount;
  String? deploymentStatus;
  String? status;
  Settings? settings;
  late Map<String, String> deploymentLinks;

  // --- newly added top‐level fields ---
  String? url;
  String? owner; // full owner URL
  late Summary summary;
  String? parent;
  String? tagString;
  String? deployedVersionId;
  late List<Permission> permissions;
  List<ExportSetting>? exportSettings;
  List<Download>? downloads;
  String? data; // data URL
  int? subscribersCount;
  dynamic accessTypes;
  Children? children;
  DataSharing? dataSharing;
  DeployedVersions? deployedVersions;

  KoboForm({
    required this.dateCreated,
    required this.dateModified,
    required this.dateDeployed,
    required this.ownerUsername,
    required this.uid,
    this.kind,
    required this.name,
    this.assetType,
    this.versionId,
    required this.hasDeployment,
    required this.deploymentActive,
    required this.deploymentSubmissionCount,
    this.deploymentStatus,
    this.status,
    this.settings,
    required this.deploymentLinks,

    // new ones
    this.url,
    this.owner,
    required this.summary,
    this.parent,
    this.tagString,
    this.deployedVersionId,
    required this.permissions,
    this.exportSettings,
    this.downloads,
    this.data,
    this.subscribersCount,
    this.accessTypes,
    this.children,
    this.dataSharing,
    this.deployedVersions,
  });

  KoboForm.fromJson(Map<String, dynamic> json) {
    // --- original parsing ---
    dateCreated = json['date_created'] ?? '';
    dateModified = json['date_modified'] ?? '';
    dateDeployed = json['date_deployed'] ?? '';
    ownerUsername = json['owner__username'] ?? '';
    uid = json['uid'].toString();
    kind = json['kind'];
    name = json['name'] != null ? json['name'].toString() : '';
    assetType = json['asset_type'];
    versionId = json['version_id'];
    hasDeployment = json['has_deployment'] ?? false;
    deploymentActive = json['deployment__active'] ?? false;
    deploymentSubmissionCount = json['deployment__submission_count'];
    deploymentStatus = json['deployment_status'];
    status = json['status'];
    settings =
        json['settings'] != null ? Settings.fromJson(json['settings']) : null;
    deploymentLinks =
        json['deployment__links'] != null
            ? Map<String, String>.from(json['deployment__links'])
            : {};
    // --- new parsing ---
    url = json['url'].toString();
    owner = json['owner'].toString();
    summary =
        json['summary'] != null
            ? Summary.fromJson(json['summary'])
            : Summary.empty();
    parent = json['parent'].toString();
    tagString = json['tag_string'].toString();
    deployedVersionId = json['deployed_version_id'].toString();
    permissions =
        (json['permissions'] != null
            ? (json['permissions'] as List<dynamic>?)
                ?.map((e) => Permission.fromJson(e))
                .toList()
            : [])!;
    exportSettings =
        json['export_settings'] != null
            ? (json['export_settings'] as List<dynamic>?)
                ?.map((e) => ExportSetting.fromJson(e))
                .toList()
            : [];
    downloads =
        json['downloads'] != null
            ? (json['downloads'] as List<dynamic>?)
                ?.map((e) => Download.fromJson(e))
                .toList()
            : [];
    data = json['data'];
    subscribersCount = json['subscribers_count'];
    accessTypes = json['access_types'];
    children =
        json['children'] != null ? Children.fromJson(json['children']) : null;
    dataSharing =
        json['data_sharing'] != null
            ? DataSharing.fromJson(json['data_sharing'])
            : null;

    deployedVersions =
        json['deployed_versions'] != null
            ? DeployedVersions.fromJson(json['deployed_versions'])
            : null;
  }
}

// --- nested types (you can move them to their own files) ---

class Summary {
  bool geo;
  List<String> labels;
  List<String> columns;
  bool lockAll;
  bool lockAny;
  List<String> languages;
  int rowCount;
  NameQuality nameQuality;
  String defaultTranslation;

  Summary({
    required this.geo,
    required this.labels,
    required this.columns,
    required this.lockAll,
    required this.lockAny,
    required this.languages,
    required this.rowCount,
    required this.nameQuality,
    required this.defaultTranslation,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      geo: json['geo'] ?? false,
      labels:
          json['labels'] != null
              ? List<String>.from(json['labels'].whereType<String>())
              : [],
      columns:
          json['columns'] != null
              ? List<String>.from(json['columns'].whereType<String>())
              : [],
      lockAll: json['lock_all'] ?? false,
      lockAny: json['lock_any'] ?? false,
      languages:
          json['languages'] != null
              ? List<String>.from(json['languages'].whereType<String>())
              : [],
      rowCount: json['row_count'] ?? 0,
      nameQuality:
          json['name_quality'] != null
              ? NameQuality.fromJson(json['name_quality'])
              : NameQuality.empty(),
      defaultTranslation:
          json['default_translation'] == null
              ? ''
              : json['default_translation'].toString(),
    );
  }

  static Summary empty() {
    return Summary(
      geo: false,
      labels: [],
      columns: [],
      lockAll: false,
      lockAny: false,
      languages: [],
      rowCount: 0,
      nameQuality: NameQuality.empty(),
      defaultTranslation: '',
    );
  }

  Map<String, dynamic> toJson() => {
    'geo': geo,
    'labels': labels,
    'columns': columns,
    'lock_all': lockAll,
    'lock_any': lockAny,
    'languages': languages,
    'row_count': rowCount,
    'name_quality': nameQuality.toJson(),
    'default_translation': defaultTranslation,
  };
}

class NameQuality {
  int ok;
  int bad;
  int good;
  int total;
  Map<String, dynamic> firsts;

  NameQuality({
    required this.ok,
    required this.bad,
    required this.good,
    required this.total,
    required this.firsts,
  });

  factory NameQuality.fromJson(Map<String, dynamic> json) => NameQuality(
    ok: json['ok'] ?? 0,
    bad: json['bad'] ?? 0,
    good: json['good'] ?? 0,
    total: json['total'] ?? 0,
    firsts:
        json['firsts'] != null ? json['firsts'] as Map<String, dynamic> : {},
  );
  static NameQuality empty() =>
      NameQuality(ok: 0, bad: 0, good: 0, total: 0, firsts: {});
  Map<String, dynamic> toJson() => {
    'ok': ok,
    'bad': bad,
    'good': good,
    'total': total,
    'firsts': firsts,
  };
}

class Permission {
  String url;
  String user;
  String permission;
  String label;

  Permission({
    required this.url,
    required this.user,
    required this.permission,
    required this.label,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    url: json['url'].toString(),
    user: json['user'].toString(),
    permission: json['permission'].toString(),
    label: json['label'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'user': user,
    'permission': permission,
    'label': label,
  };
}

class ExportSetting {
  // no fields in example
  ExportSetting();

  factory ExportSetting.fromJson(Map<String, dynamic> json) => ExportSetting();

  Map<String, dynamic> toJson() => {};
}

class Download {
  String format;
  String url;

  Download({required this.format, required this.url});

  factory Download.fromJson(Map<String, dynamic> json) => Download(
    format: json['format'].toString(),
    url: json['url'].toString().replaceFirst(
      "/?format=json",
      "",
    ), //hardcoded remove formatJson from url
  );

  Map<String, dynamic> toJson() => {'format': format, 'url': url};
}

class Children {
  int count;

  Children({required this.count});

  factory Children.fromJson(Map<String, dynamic> json) =>
      Children(count: json['count'] ?? 0);

  Map<String, dynamic> toJson() => {'count': count};
}

class DataSharing {
  List<String> fields;
  bool enabled;

  DataSharing({required this.fields, required this.enabled});

  factory DataSharing.fromJson(Map<String, dynamic> json) => DataSharing(
    fields: List<String>.from(json['fields'] ?? []),
    enabled: json['enabled'] ?? false,
  );

  Map<String, dynamic> toJson() => {'fields': fields, 'enabled': enabled};
}

class Settings {
  Sector? sector;
  late List<Country> country;
  DataTable? dataTable;
  late String description;
  String? organization;
  List<String>? countryCodes;

  Settings({
    this.sector,
    required this.country,
    this.dataTable,
    required this.description,
    this.organization,
    this.countryCodes,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    sector = json['sector'] != null ? Sector.fromJson(json['sector']) : null;
    country = <Country>[];
    if (json['country'] != null) {
      json['country'].forEach((v) {
        country.add(Country.fromJson(v));
      });
    }
    dataTable =
        json['data-table'] != null
            ? DataTable.fromJson(json['data-table'])
            : null;
    description =
        json['description'] != null ? json['description'].toString() : '';
    organization = json['organization'];
    countryCodes =
        json['country_codes'] != null
            ? json['country_codes'].cast<String>()
            : [];
  }
}

class Sector {
  String? label;
  String? value;

  Sector({this.label, this.value});

  Sector.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class DataTable {
  String? frozenColumn;
  bool? showHxlTags;
  bool? showGroupName;
  int? translationIndex;

  DataTable({
    this.frozenColumn,
    this.showHxlTags,
    this.showGroupName,
    this.translationIndex,
  });

  DataTable.fromJson(Map<String, dynamic> json) {
    frozenColumn = json['frozen-column'];
    showHxlTags = json['show-hxl-tags'];
    showGroupName = json['show-group-name'];
    translationIndex = json['translation-index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['frozen-column'] = frozenColumn;
    data['show-hxl-tags'] = showHxlTags;
    data['show-group-name'] = showGroupName;
    data['translation-index'] = translationIndex;
    return data;
  }
}

class Country {
  late String label;
  late String value;

  Country({required this.label, required this.value});

  Country.fromJson(Map<String, dynamic> json) {
    label = json['label'].toString();
    value = json['value'].toString();
  }
}

class DeployedVersions {
  final int count;
  final String? next;
  final String? previous;
  final List<Version> results;

  DeployedVersions({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory DeployedVersions.fromJson(Map<String, dynamic> json) {
    var resultsJson = json['results'] as List<dynamic>;
    List<Version> versions =
        resultsJson.map((e) => Version.fromJson(e)).toList();

    return DeployedVersions(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: versions,
    );
  }
}

class Version {
  final String uid;
  final String url;
  final String contentHash;
  final String dateDeployed;
  final String dateModified;

  Version({
    required this.uid,
    required this.url,
    required this.contentHash,
    required this.dateDeployed,
    required this.dateModified,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      uid: json['uid'] ?? "",
      url: json['url'] ?? "",
      contentHash: json['content_hash'] ?? "",
      dateDeployed: json['date_deployed'] ?? "",
      dateModified: json['date_modified'] ?? "",
    );
  }
}
