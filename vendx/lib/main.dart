import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:vendx/app.dart';

import 'features/cart/controller/cart_state.dart';

void main() {
  Get.put(CartState());

  WidgetsFlutterBinding.ensureInitialized();

  // Set your Stripe publishable key
  Stripe.publishableKey =
      "pk_test_51QGFjuBXNmKWsHfDKjYaEDiLfUpzlMjynIrPWXE6hUTqKBtOpTBZABUSXfNbmDafmskpfeWTbVIpP2f1yqRGsFLJ00erWCjFsZ";

  // Optional: Enable Apple Pay and Google Pay
  Stripe.merchantIdentifier = 'merchant.identifier'; // For Apple Pay
  Stripe.urlScheme = 'myapp'; // For return URL (Google Pay/others)
  Stripe.instance.applySettings();
  runApp(const MyApp());
}
