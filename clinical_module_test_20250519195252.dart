import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_platform_interface/src/types/product_details_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clinical_module/clinical_module.dart';
import 'dart:convert';

class MockIAP extends Mock implements InAppPurchasePlatform {}
class MockClient extends Mock implements http.Client {}
class MockStorage extends Mock implements FlutterSecureStorage {}


