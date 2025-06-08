enum ImageSize { small, medium, large, original }

extension ImageSizeExtension on ImageSize {
  String get toValue {
    switch (this) {
      case ImageSize.small:
        return 'small';
      case ImageSize.medium:
        return 'medium';
      case ImageSize.large:
        return 'large';
      case ImageSize.original:
        return 'original';
    }
  }
}
