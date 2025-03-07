import 'package:flutter/material.dart';
import 'package:vendx/utlis/constants/colors.dart';

class OrderTabs extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabSelected;

  const OrderTabs({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: VendxColors.primary300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(0),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedTabIndex == 0
                      ? VendxColors.primary900
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Redeem all',
                    style: TextStyle(
                      color:
                          selectedTabIndex == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(1),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedTabIndex == 1
                      ? VendxColors.primary900
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Cherry Pick',
                    style: TextStyle(
                      color:
                          selectedTabIndex == 1 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
