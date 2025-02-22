import 'package:flutter/material.dart';
import 'package:vendx/utlis/constants/colors.dart';

class CustomAuthButton extends StatelessWidget {
  final bool isDisabled;
  final bool isLoading;
  final Color backgroundColor;
  final String labelText;
  final String loadinglText;
  final VoidCallback onPress;

  const CustomAuthButton({
    super.key,
    required this.onPress,
    required this.labelText,
    this.isLoading = false,
    this.isDisabled = false,
    this.loadinglText = "Loading...",
    this.backgroundColor = VendxColors.primary900,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: VendxColors.primary50, width: 0),
      ),
      onPressed: !(isDisabled || isLoading) ? onPress : null,
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  loadinglText,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )
          : Text(
              labelText,
              style: const TextStyle(color: Colors.white),
            ),
    );
  }
}
