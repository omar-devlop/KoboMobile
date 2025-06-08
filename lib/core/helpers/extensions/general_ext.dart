extension NullStringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension StringExtension on String {
  String get lastAfterSlash {
    if (!contains('/')) return this;
    return split('/').last;
  }

  /// A Dart extension on `String` to replace spaces with underscores
  /// Returns a new string where all spaces (' ') are replaced by underscores ('_').
  String get underscored {
    return replaceAll(' ', '_');
  }

  /// Returns the string without the '?format=json' suffix, if present at the end.
  String get withoutFormatJson {
    const suffix = '?format=json';
    return endsWith(suffix) ? substring(0, length - suffix.length) : this;
  }
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}
