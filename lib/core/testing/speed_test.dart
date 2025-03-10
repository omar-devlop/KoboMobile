import 'package:flutter/widgets.dart';

class SpeedTest {
  static Stopwatch stopwatch = Stopwatch();

  static void start() {
    stopwatch.reset();
    stopwatch.start();
  }

  static void stop({String? msg}) {
    stopwatch.stop();
    double seconds = stopwatch.elapsedMicroseconds / 1000000;

    debugPrint('TIME [$msg]: ${seconds.toStringAsFixed(5)} s');
  }
}
