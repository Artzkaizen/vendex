import 'package:flutter/material.dart';
// import 'package:vendx/config/routes/app_router.dart';
import 'package:vendx/features/auth/view/widgets/auth_layout.dart';
import 'package:vendx/features/auth/view/widgets/button.dart';
import 'package:vendx/features/auth/view/widgets/form_field.dart';
import 'package:vendx/router/init.dart';
import 'package:vendx/utlis/constants/colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Reset Password",
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 16),
            const AuthTextFieldContainer(labelText: 'New Password'),
            const SizedBox(height: 16),
            const AuthTextFieldContainer(labelText: 'Repeat Password'),
            const SizedBox(height: 32),
            CustomAuthButton(labelText: 'Submit', onPress: () {}),
            const Spacer(),
            TextButton(
              onPressed: () => AppRouter.go(context, AppRoutes.signup),
              child: Text('Cancel',
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
