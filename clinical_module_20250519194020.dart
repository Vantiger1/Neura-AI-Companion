

import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart' show PurchaseStatus, PurchaseParam, ProductDetails, PurchaseDetails;
import 'package:http/http.dart' as http;
import 'dart:convert';

// Dummy Patient class for demonstration; replace with actual implementation or import.
class Patient {
  final Map<String, dynamic> data;
  Patient(this.data);

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(json);
  Map<String, dynamic> toJson() => data;
}

class ClinicalModule {
  // Define your subscription ID here
  static const String _kSubscriptionId = 'your_subscription_id';

  static final InAppPurchase _iap = InAppPurchase.instance;
  static late StreamSubscription<List<PurchaseDetails>> _subscription;
  static late ProductDetails _product;
  static bool _available = false;
  static bool _subscribed = false;

  /// Initialize the module: setup in-app purchase and verify subscription.
  static Future<void> init() async {
    _available = await _iap.isAvailable();
    if (!_available) {
      throw Exception('In-app purchases not available');
    }
    // Listen to purchase updates
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(_onPurchaseUpdated, onDone: () {
      _subscription.cancel();
    });

    // Load product details
    final response = await _iap.queryProductDetails({_kSubscriptionId});
    if (response.notFoundIDs.isNotEmpty) {
      throw Exception('Subscription ID not found in store');
    }
    _product = response.productDetails.first;

    // Check previous purchases
    final past = await _iap.queryPastPurchases();
    for (var purchase in past.pastPurchases) {
      if (purchase.productID == _kSubscriptionId &&
          purchase.status == PurchaseStatus.purchased) {
        _subscribed = true;
      }
    }
    if (!_subscribed) {
      throw Exception('Professional subscription required');
    }
    developer.log('ClinicalModule initialized: subscription verified',
        name: 'ClinicalModule');
  }

  static void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.productID == _kSubscriptionId &&
          purchase.status == PurchaseStatus.purchased) {
        _subscribed = true;
      }
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  /// Launch purchase flow
  static Future<void> purchase() async {
    final purchaseParam = PurchaseParam(productDetails: _product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Fetch patient data via FHIR API.
  static Future<Patient> fetchPatient(String patientId, String fhirServer, String apiKey) async {
    if (!_subscribed) throw Exception('Not subscribed');
    final url = Uri.parse('\$fhirServer/Patient/\$patientId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer \$apiKey',
      'Accept': 'application/fhir+json'
    });
    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch patient: \${response.statusCode}');
    }
  }

  /// Send an Observation resource to FHIR server.
  static Future<void> sendObservation(Observation obs, String fhirServer, String apiKey) async {
    if (!_subscribed) throw Exception('Not subscribed');
    final url = Uri.parse('\$fhirServer/Observation');
    final body = jsonEncode(obs.toJson());
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer \$apiKey',
      'Content-Type': 'application/fhir+json'
    }, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      developer.log('Observation sent', name: 'ClinicalModule');
    } else {
      throw Exception('Failed to send observation: \${response.statusCode}');
    }
  }

  /// Dispose resources
  static Future<void> dispose() async {
    await _subscription.cancel();
  }
}
