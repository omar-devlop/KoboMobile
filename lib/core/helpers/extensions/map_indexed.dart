extension MapIndexed<K, V> on Iterable<MapEntry<K, V>> {
  Iterable<T> mapIndexed<T>(T Function(int, MapEntry<K, V>) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
