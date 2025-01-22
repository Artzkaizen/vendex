import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendx/features/auth/view/widgets/button.dart';

class StripeService {
  static const String baseUrl = 'http://localhost:4000';

  Future<Map<String, dynamic>> createPaymentIntent(
      Map<String, dynamic> paymentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments/stripe/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(paymentData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment intent');
    }
    return jsonDecode(response.body);
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final StripeService _stripeService = StripeService();

  Future<void> handleCheckout() async {
    try {
      // Step 1: Create payment intent
      final paymentData = {
        "amount": 5000, // Example: 50.00 USD
        "email": "jane.doe@srh.de",
        "userId": "7e6d4b5c-f8c1-4d72-8e5b-d942a9a8a13b",
      };
      final paymentSheetParams =
          await _stripeService.createPaymentIntent(paymentData);

      // Step 2: Initialize payment sheet
      Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentSheetParams['paymentIntent'],
          customerId: paymentSheetParams['customerId'],
          customerEphemeralKeySecret: paymentSheetParams['ephemeralKey'],
          merchantDisplayName: 'Example, Inc.',
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'DE',
          ),
          style: ThemeMode.system,
        ),
      );

      // Step 3: Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomAuthButton(
        labelText: "Checkout",
        onPress: handleCheckout,
      ),
    );
  }
}
