// test/activity_posture_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:activity_posture/activity_posture.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MockAccelerometerApi implements AccelerometerApi {
  @override
  Stream<AccelerometerEvent> get stream =>
      Stream.fromIterable([AccelerometerEvent(8.0, 0.0, 0.0)]);
}

void main() {
  late ActivityPosture module;

  setUp(() {
    module = ActivityPosture(MockAccelerometerApi());
    module.init();
  });

  test('isSlouch detects slouch correctly', () {
    final event = AccelerometerEvent(8.0, 0.0, 0.0);
    expect(ActivityPosture.isSlouch(event), isTrue);
  });

  test('stream emits events', () async {
    final events = <AccelerometerEvent>[];
    final sub = module.events.listen(events.add);
    await Future.delayed(Duration(milliseconds: 100));
    expect(events, isNotEmpty);
    await sub.cancel();
    module.dispose();
  });
}