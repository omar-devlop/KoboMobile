extension SafeIndex<T> on List<T> {
  T getIndexOrFirst(int index) {
    return (index >= length || index < 0) ? first : this[index];
  }
}
