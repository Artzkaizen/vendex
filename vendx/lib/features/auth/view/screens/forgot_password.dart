import 'package:flutter/material.dart';
import 'package:vendx/features/auth/view/widgets/auth_layout.dart';
import 'package:vendx/features/auth/view/widgets/button.dart';
import 'package:vendx/features/auth/view/widgets/form_field.dart';
import 'package:vendx/router/init.dart';
import 'package:vendx/router/routes.dart';
import 'package:vendx/utlis/constants/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Forgot Password",
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 16),
            const AuthTextFieldContainer(labelText: 'Email'),
            const SizedBox(height: 32),
            CustomAuthButton(
                labelText: 'Submit',
                onPress: () => AppRouter.go(context, AppRoutes.resetPassword)),
            const Spacer(),
            TextButton(
              onPressed: () => AppRouter.go(context, AppRoutes.signup),
              child: Text('Back to Login',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: VendxColors.primary900)),
            ),
          ],
        ),
      ),
    );
  }
}
