import 'package:flutter/material.dart';

class AuthTextFieldContainer extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  const AuthTextFieldContainer({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: AuthTextField(
        labelText: labelText,
        obscureText: obscureText,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  const AuthTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
