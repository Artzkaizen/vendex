import 'package:flutter/material.dart';
import 'package:vendx/utlis/constants/colors.dart';

class AuthTextFieldContainer extends StatelessWidget {
  final String labelText;
  final bool obscureText;

  const AuthTextFieldContainer({
    super.key,
    required this.labelText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? VendxColors.neutral500
            : VendxColors.neutral100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AuthTextField(
        labelText: labelText,
        obscureText: obscureText,
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;

  const AuthTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      obscureText: obscureText,
    );
  }
}
