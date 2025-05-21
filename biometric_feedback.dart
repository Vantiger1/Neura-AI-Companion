library biometric_feedback;

import 'dart:async';
import 'dart:developer';
import 'package:health/health.dart';

/// Abstraction for Health API to allow mocking
abstract class HealthApi {
  Future<bool> requestAuthorization(List<HealthDataType> types);
  Future<List<HealthDataPoint>> getData(DateTime start, DateTime end, List<HealthDataType> types);
}

/// Real implementation using HealthFactory
class HealthApiImpl implements HealthApi {
  final HealthFactory _health = HealthFactory();
  @override
  Future<bool> requestAuthorization(List<HealthDataType> types) =>
      _health.requestAuthorization(types);

  @override
  Future<List<HealthDataPoint>> getData(DateTime start, DateTime end, List<HealthDataType> types) =>
      _health.getHealthDataFromTypes(start, end, types);
}

/// Biometric feedback module
class BiometricFeedback {
  final HealthApi api;

  BiometricFeedback(this.api);

  /// Initialize the module, request permissions
  static Future<BiometricFeedback> init(HealthApi api) async {
    final granted = await api.requestAuthorization([
      HealthDataType.HEART_RATE,
      HealthDataType.HEART_RATE_VARIABILITY
    ]);
    if (!granted) {
      throw Exception('Health permissions denied');
    }
    developer.log('Health permissions granted', name: 'BiometricFeedback');
    return BiometricFeedback(api);
  }

  /// Fetch average HRV between start/end times
  Future<double?> fetchAverageHrv(DateTime start, DateTime end) async {
    try {
      final data = await api
          .getData(start, end, [HealthDataType.HEART_RATE_VARIABILITY])
          .timeout(Duration(seconds: 5), onTimeout: () => []);
      if (data.isEmpty) return null;
      final values = data.map((e) => e.value as double).toList();
      final avg = values.reduce((a, b) => a + b) / values.length;
      developer.log('Computed HRV average: \$avg', name: 'BiometricFeedback');
      return avg;
    } catch (e) {
      developer.log('Error fetching HRV: \$e', name: 'BiometricFeedback', level: 1000);
      rethrow;
    }
  }
}