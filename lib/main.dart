import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:vendx/app.dart';
import 'package:vendx/utlis/constants/env.dart';

import 'features/cart/controller/cart_state.dart';

void main() async {
  Get.put(CartState());

  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = Env.stripePublishableKey;
  Stripe.merchantIdentifier = Env.merchantIdentifier;
  Stripe.urlScheme = Env.stripeUrlScheme;
  Stripe.instance.applySettings();

  runApp(const MyApp());
}
