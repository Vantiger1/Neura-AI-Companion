// test/biometric_feedback_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:biometric_feedback/biometric_feedback.dart';

class MockHealthApi extends Mock implements HealthApi {}

void main() {
  late MockHealthApi mockApi;
  late BiometricFeedback module;

  setUp(() async {
    mockApi = MockHealthApi();
  });

  test('init throws if permission denied', () async {
    when(mockApi.requestAuthorization(any)).thenAnswer((_) async => false);
    expect(() async => await BiometricFeedback.init(mockApi), throwsException);
  });

  test('fetchAverageHrv returns correct average', () async {
    final now = DateTime.now();
    when(mockApi.requestAuthorization(any)).thenAnswer((_) async => true);
    when(mockApi.getData(any, any, any)).thenAnswer((_) async => [
      HealthDataPoint(now, 50.0),
      HealthDataPoint(now, 70.0)
    ]);
    module = await BiometricFeedback.init(mockApi);
    final avg = await module.fetchAverageHrv(now, now);
    expect(avg, 60.0);
  });
}