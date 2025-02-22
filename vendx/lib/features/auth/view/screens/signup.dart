import 'package:flutter/material.dart';

import 'package:vendx/features/auth/view/widgets/auth_layout.dart';
import 'package:vendx/features/auth/view/widgets/button.dart';
import 'package:vendx/features/auth/view/widgets/form_field.dart';
import 'package:vendx/router/init.dart';
import 'package:vendx/router/routes.dart';
import 'package:vendx/utlis/constants/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    const emailRegex = r'^[^@]+@[^@]+\.[^@]+';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint('Email: $_email, Password: $_password');
      // Proceed with signup logic
      AppRouter.go(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 16),
                AuthTextFieldContainer(
                  labelText: 'Email',
                  onSaved: (value) => _email = value,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                AuthTextFieldContainer(
                  labelText: 'Password',
                  obscureText: true,
                  onSaved: (value) => _password = value,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                CustomAuthButton(
                  labelText: 'Sign Up',
                  loadinglText: "Submitting...",
                  onPress: _submit,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account ?',
                        style: Theme.of(context).textTheme.titleMedium),
                    TextButton(
                      onPressed: () => AppRouter.go(context, AppRoutes.login),
                      child: Text('Login',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: VendxColors.primary900)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
