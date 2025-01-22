import 'package:flutter/material.dart';
import 'package:vendx/config/routes/app_router.dart';
import 'package:vendx/features/auth/view/widgets/auth_layout.dart';
import 'package:vendx/features/auth/view/widgets/button.dart';
import 'package:vendx/features/auth/view/widgets/form_field.dart';
import 'package:vendx/utlis/constants/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Center(
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
            const AuthTextFieldContainer(labelText: 'Email'),
            const SizedBox(height: 16),
            const AuthTextFieldContainer(
                labelText: 'Password', obscureText: true),
            const SizedBox(height: 16),
            CustomAuthButton(
              labelText: 'Sign Up',
              loadinglText: "Submitting...",
              onPress: () => AppRouter.go(context, AppRoutes.home),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account ?',
                    style: Theme.of(context).textTheme.titleMedium),
                TextButton(
                  onPressed: () => AppRouter.go(context, AppRoutes.login),
                  child: Text('Login',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: VendxColors.primary900)),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
