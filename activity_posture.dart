library activity_posture;

import 'dart:async';
import 'dart:developer';
import 'package:sensors_plus/sensors_plus.dart';

/// Abstraction for accelerometer API
abstract class AccelerometerApi {
  Stream<AccelerometerEvent> get stream;
}

/// Real implementation using sensors_plus
class AccelerometerApiImpl implements AccelerometerApi {
  @override
  Stream<AccelerometerEvent> get stream => accelerometerEvents;
}

/// Activity and posture detection
class ActivityPosture {
  final AccelerometerApi api;
  late final StreamController<AccelerometerEvent> _controller;
  late final StreamSubscription _subscription;

  ActivityPosture(this.api) {
    _controller = StreamController.broadcast();
  }

  /// Initialize listening
  void init() {
    _subscription = api.stream.listen((event) {
      _controller.add(event);
      developer.log('Accel event: x=\${event.x}', name: 'ActivityPosture');
    });
  }

  /// Stream of raw accelerometer events
  Stream<AccelerometerEvent> get events => _controller.stream;

  /// Simple slouch detection logic
  static bool isSlouch(AccelerometerEvent e, {double threshold = 7.0}) {
    return e.x.abs() > threshold;
  }

  /// Clean up resources
  void dispose() {
    _subscription.cancel();
    _controller.close();
    developer.log('ActivityPosture disposed', name: 'ActivityPosture');
  }
}