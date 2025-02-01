import 'package:flutter/material.dart';
import 'package:vendx/utlis/theme/elevated_button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Payment Success',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
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
              const SizedBox(height: 24),
              const Text(
                'Payment Successful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                    _buildGuideline('2. Proceed'),
                    _buildGuideline('3. Present the Qr Code to the Scanner'),
                    _buildGuideline(
                        '4. Take you products from the open cabins'),
                    _buildGuideline('5. Confirm all doors are closed properly'),
                    _buildGuideline('6. Have a blessed day'),
                    _buildGuideline('7. Get Help if Needed'),
                  ],
                ),
              ),
              const Spacer(),
              // Buttons
              ElevatedButtonTheme(
                data: VendxElevatedButton.light,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Later'),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButtonTheme(
                data: VendxElevatedButton.dark,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Redeem Now'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.headset_mic),
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
