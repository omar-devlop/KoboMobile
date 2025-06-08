import 'package:flutter/widgets.dart';

class SpeedTest {
  static final Stopwatch _stopwatch = Stopwatch();

  static void start() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  static void stop({String? msg}) {
    _stopwatch.stop();
    double seconds = _stopwatch.elapsedMicroseconds / 1000000;

    debugPrint('TIME [$msg]: ${seconds.toStringAsFixed(5)} s');
  }
}
