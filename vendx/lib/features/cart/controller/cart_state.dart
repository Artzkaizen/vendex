import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:vendx/features/cart/model/cart_item.dart';
import 'package:vendx/features/product/model/products.dart';

class CartState extends GetxController {
  final RxList<CartItemModel> _items = <CartItemModel>[].obs;

  List<CartItemModel> get items => _items.toList();
  int get itemCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  int getItemQuantity(ProductModel product) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItemModel(product: product, quantity: 0),
    );
    return existingItem.quantity;
  }

  int get totalQuantity => _items.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

  final RxBool _isCheckoutPending = false.obs;

  bool get isCheckoutPending => _isCheckoutPending.value;

  void setCheckoutPending(bool value) {
    _isCheckoutPending.value = value;
  }

  double getTotalAmount() {
    return _items.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price.netPrice * item.quantity),
    );
  }

  // Add or remove items from the cart
  void manageItem(ProductModel product, String action) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Update item quantity
      final currentItem = _items[existingItemIndex];
      if (action == "remove" && currentItem.quantity == 1) {
        _items.removeAt(existingItemIndex);
      } else {
        _items[existingItemIndex] = CartItemModel(
          product: currentItem.product,
          quantity: currentItem.quantity + (action == "add" ? 1 : -1),
        );
      }
    } else if (action == "add") {
      // Add new item to the cart
      _items.add(CartItemModel(product: product, quantity: 1));
    }
  }

  // Handle checkout process
  Future<void> handleCheckout(BuildContext context) async {
    try {
      // Step 1: Create a payment intent
      setCheckoutPending(true);
      final response = await http.post(
        Uri.parse('http://localhost:4000/payments/stripe/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": "7e6d4b5c-f8c1-4d72-8e5b-d942a9a8a13b",
          "email": "user@srh.de",
          "amount": getTotalAmount(),
        }),
      );
      setCheckoutPending(false);

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to create payment intent. Server responded with status code: ${response.statusCode}');
      }

      final paymentData = jsonDecode(response.body);

      // Validate the payment data
      if (paymentData['paymentIntent'] == null ||
          paymentData['customerId'] == null ||
          paymentData['ephemeralKey'] == null) {
        throw Exception('Invalid payment data received from server.');
      }

      // Step 2: Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentData['paymentIntent'],
          customerId: paymentData['customerId'],
          customerEphemeralKeySecret: paymentData['ephemeralKey'],
          merchantDisplayName: 'Example, Inc.',
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'DE',
          ),
          style: ThemeMode.system,
        ),
      );

      // Step 3: Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Handle successful payment
      // Success flow
      Get.snackbar('Success', 'Payment completed successfully!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      // Clear the cart after successful payment
      _items.clear();
      // Navigate to a success page
      // Get.toNamed('/success');
    } catch (e) {
      // Handle errors
      if (e is StripeException) {
        // print('Error from Stripe: ${e.error.localizedMessage}');
        Get.snackbar('Error', '${e.error.localizedMessage}',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', 'Payment failed: $e',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    }
  }

  // Reset the cart
  void resetCart() {
    _items.clear();
  }
}
