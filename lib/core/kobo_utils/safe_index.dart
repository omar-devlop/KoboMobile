extension SafeIndex on List<String> {
  String getIndexOrFirst(int index) {
    return (index >= length) ? first : this[index];
  }
}
