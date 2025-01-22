import 'package:flutter/material.dart';
import 'package:vendx/utlis/constants/colors.dart';

class BuyNowButton extends StatelessWidget {
  final Function() onBuyNow;
  final Function() onAddQuantity;
  final int quantity;

  const BuyNowButton({
    super.key,
    required this.onBuyNow,
    required this.onAddQuantity,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Buy Now Button
        Expanded(
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBuyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: VendxColors.primary900,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Quantity Counter Button
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF3B82F6),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAddQuantity,
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Color(0xFF3B82F6),
                      size: 24,
                    ),
                  ),
                ),
              ),
              if (quantity > 0)
                Positioned(
                  right: -1,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
