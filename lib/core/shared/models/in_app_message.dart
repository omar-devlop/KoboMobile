class AppMessage {
  final String url;
  final String uid;
  final String title;
  final String snippet;
  final String body;
  final HtmlContent html;
  final Map<String, dynamic> interactions;
  final bool alwaysDisplayAsNew;

  AppMessage({
    required this.url,
    required this.uid,
    required this.title,
    required this.snippet,
    required this.body,
    required this.html,
    required this.interactions,
    required this.alwaysDisplayAsNew,
  });

  factory AppMessage.fromJson(Map<String, dynamic> json) {
    return AppMessage(
      url: json['url'].toString(),
      uid: json['uid'].toString(),
      title: json['title'].toString(),
      snippet: json['snippet'].toString(),
      body: json['body'].toString(),
      html: HtmlContent.fromJson(json['html'] ?? {}),
      interactions: Map<String, dynamic>.from(json['interactions'] ?? {}),
      alwaysDisplayAsNew: json['always_display_as_new'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'uid': uid,
      'title': title,
      'snippet': snippet,
      'body': body,
      'html': html.toJson(),
      'interactions': interactions,
      'always_display_as_new': alwaysDisplayAsNew,
    };
  }
}

class HtmlContent {
  final String snippet;
  final String body;

  HtmlContent({required this.snippet, required this.body});

  factory HtmlContent.fromJson(Map<String, dynamic> json) {
    return HtmlContent(
      snippet: json['snippet'].toString(),
      body: json['body'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'snippet': snippet, 'body': body};
  }
}
