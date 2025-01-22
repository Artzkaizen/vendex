import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final bool isDisabled;
  final bool isLoading;
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
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: !(isDisabled || isLoading) ? onPress : null,
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
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
