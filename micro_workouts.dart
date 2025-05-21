library micro_workouts;

import 'dart:async';

class MicroWorkouts {
  /// Example 30-sec stretch timer
  static void startStretchRoutine(void Function(int) tickCallback) {
    int seconds = 30;
    Timer.periodic(Duration(seconds: 1), (t) {
      seconds--;
      tickCallback(seconds);
      if (seconds <= 0) t.cancel();
    });
  }
}