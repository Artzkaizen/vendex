import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeCheckout {
  static Future<void> createPaymentIntent({
    required BuildContext context,
    required int amount,
    required String email,
    required String userId,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      // Step 1: Create Payment Intent
      final response = await http.post(
        Uri.parse('https://localhost:4000/payments/stripe/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'email': email,
          'userId': userId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment intent');
      }

      final data = jsonDecode(response.body);
      final customerId = data['customerId'];
      final ephemeralKey = data['ephemeralKey'];
      final paymentIntent = data['paymentIntent'];

      // Step 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
          merchantDisplayName: 'Example, Inc.',
          style: ThemeMode.light,
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'DE',
          ),
          // returnURL: 'yourapp://(tabs)', // Ensure your app handles deep linking
        ),
      );

      // Step 3: Present Payment Sheet
      if (context.mounted) {
        _presentPaymentSheet(
          onSuccess: onSuccess,
          onError: onError,
        );
      }
    } catch (error) {
      onError(error.toString());
    }
  }

  static Future<void> _presentPaymentSheet({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      onSuccess();
    } catch (error) {
      onError('Payment failed: $error');
    }
  }
}
