import 'package:flutter/material.dart';
import 'package:vendx/features/auth/view/widgets/auth_layout.dart';
import 'package:vendx/features/auth/view/widgets/button.dart';
import 'package:vendx/features/auth/view/widgets/form_field.dart';
import 'package:vendx/router/init.dart';
import 'package:vendx/utlis/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Simple email validation regex
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
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Proceed with login logic
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
                    "Login",
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
                  labelText: 'Login',
                  onPress: _submit,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account ?',
                        style: Theme.of(context).textTheme.titleMedium),
                    TextButton(
                      onPressed: () => AppRouter.go(context, AppRoutes.signup),
                      child: Text('Sign Up',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: VendxColors.primary900)),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () =>
                      AppRouter.go(context, AppRoutes.forgotPassword),
                  child: Text('Forgot Password ?',
                      style: Theme.of(context).textTheme.labelSmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
