class Attachment {
  final String downloadUrl;
  final String downloadLargeUrl;
  final String downloadMediumUrl;
  final String downloadSmallUrl;
  final String mimetype;
  final String filename;
  final String instance;
  final String xform;
  final String id;
  final String questionXpath;

  Attachment({
    required this.downloadUrl,
    required this.downloadLargeUrl,
    required this.downloadMediumUrl,
    required this.downloadSmallUrl,
    required this.mimetype,
    required this.filename,
    required this.instance,
    required this.xform,
    required this.id,
    required this.questionXpath,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      downloadUrl: json['download_url'].toString(),
      downloadLargeUrl: json['download_large_url'].toString(),
      downloadMediumUrl: json['download_medium_url'].toString(),
      downloadSmallUrl: json['download_small_url'].toString(),
      mimetype: json['mimetype'].toString(),
      filename: json['filename'].toString(),
      instance: json['instance'].toString(),
      xform: json['xform'].toString(),
      id: json['id'].toString(),
      questionXpath: json['question_xpath'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'download_url': downloadUrl,
      'download_large_url': downloadLargeUrl,
      'download_medium_url': downloadMediumUrl,
      'download_small_url': downloadSmallUrl,
      'mimetype': mimetype,
      'filename': filename,
      'instance': instance,
      'xform': xform,
      'id': id,
      'question_xpath': questionXpath,
    };
  }
}
