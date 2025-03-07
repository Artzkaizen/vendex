import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/router/routes.dart';
import 'package:vendx/utlis/constants/colors.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final OrderModel order;
  const PaymentSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Payment Successful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Success Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Guidelines Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Guidelines',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGuideline('1. Select Machine and Products to redeem'),
                    _buildGuideline('2. Present the Qr Code to the Scanner'),
                    _buildGuideline(
                        '3. Take you products from the open cabins'),
                    _buildGuideline('4. Confirm all doors are closed properly'),
                    _buildGuideline('4. Have a blessed day'),
                    _buildGuideline('6. Get Help if Needed'),
                  ],
                ),
              ),
              const Spacer(),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.goNamed(AppRoutes.home),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withAlpha(0),
                          foregroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Later',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.pushNamed(AppRoutes.orderDetails,
                              pathParameters: {'orderId': order.id.toString()},
                              extra: order);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VendxColors.primary900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Redeem Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideline(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
