class GitHubRelease {
  final String name;
  final bool prerelease;
  final DateTime publishedAt;
  final String body;
  final String htmlUrl;
  final String assetName;
  final String assetDownloadUrl;

  GitHubRelease({
    required this.name,
    required this.prerelease,
    required this.publishedAt,
    required this.body,
    required this.htmlUrl,
    required this.assetName,
    required this.assetDownloadUrl,
  });

  factory GitHubRelease.fromJson(Map<String, dynamic> json) {
    final assets = json['assets'] as List<dynamic>?;

    final apkAsset = assets?.firstWhere(
      (asset) => (asset['name'] as String).toLowerCase().endsWith('.apk'),
      orElse: () => null,
    );

    return GitHubRelease(
      name: json['name'] ?? '',
      prerelease: json['prerelease'] ?? false,
      publishedAt: DateTime.parse(json['published_at']),
      body: json['body'] ?? '',
      htmlUrl: json['html_url'] ?? '',
      assetName: apkAsset != null ? apkAsset['name'] ?? '' : '',
      assetDownloadUrl:
          apkAsset != null ? apkAsset['browser_download_url'] ?? '' : '',
    );
  }
}
