import 'package:flutter/material.dart';
import 'package:vendx/config/routes/app_router.dart';
import 'package:vendx/features/auth/view/widgets/auth_layout.dart';
import 'package:vendx/features/auth/view/widgets/button.dart';
import 'package:vendx/features/auth/view/widgets/form_field.dart';
import 'package:vendx/utlis/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Center(
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
            const AuthTextFieldContainer(labelText: 'Email'),
            const SizedBox(height: 16),
            const AuthTextFieldContainer(
                labelText: 'Password', obscureText: true),
            const SizedBox(height: 32),
            CustomAuthButton(
              labelText: 'Login',
              onPress: () => AppRouter.go(context, AppRoutes.home),
            ),
            const SizedBox(height: 16),
            TextButton(
                onPressed: () =>
                    AppRouter.go(context, AppRoutes.forgotPassword),
                child: Text('Forgot Password ?',
                    style: Theme.of(context).textTheme.titleMedium)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account ?',
                    style: Theme.of(context).textTheme.titleMedium),
                TextButton(
                  onPressed: () => AppRouter.go(context, AppRoutes.signup),
                  child: Text('Sign Up',
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
