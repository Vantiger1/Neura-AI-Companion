import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class GlobalLogger {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> logStatus({
    required String source,
    required String status,
  }) async {
    try {
      await firestore.collection('service_logs').add({
        'source': source,
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await analytics.logEvent(
        name: 'service_check',
        parameters: {
          'service': source,
          'status': status,
        },
      );
    } catch (e) {
      print("Logging error: $e");
    }
  }

  Future<void> sendAlert(String message) async {
    try {
      await firestore.collection('alerts').add({
        'alert': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await analytics.logEvent(
        name: 'critical_alert',
        parameters: {
          'message': message,
        },
      );
    } catch (e) {
      print("Alert logging error: $e");
    }
  }
}