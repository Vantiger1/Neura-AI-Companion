import 'package:in_app_purchase/in_app_purchase.dart';

class NeuraBillingManager {
  static const String neuraProductId = 'neura_addon';
  final InAppPurchase _iap = InAppPurchase.instance;

  late bool isAvailable;
  bool neuraUnlocked = false;
  List<ProductDetails> _products = [];

  Future<void> initStore() async {
    final available = await _iap.isAvailable();
    isAvailable = available;

    if (isAvailable) {
      final response = await _iap.queryProductDetails({neuraProductId});
      _products = response.productDetails.toList();

      _iap.purchaseStream.listen(_onPurchaseUpdate);
    }
  }

  List<ProductDetails> get products => _products;

  Future<void> buyNeuraAddon() async {
    if (_products.isNotEmpty) {
      final product = _products.firstWhere((p) => p.id == neuraProductId);
      final purchaseParam = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.productID == neuraProductId && purchase.status == PurchaseStatus.purchased) {
        neuraUnlocked = true;
        InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  bool get isNeuraUnlocked => neuraUnlocked;
}