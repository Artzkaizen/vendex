import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendx/features/auth/view/widgets/auth_provider.dart';
import 'package:vendx/features/auth/view/widgets/button.dart';
import 'package:vendx/router/init.dart';
import 'package:vendx/router/routes.dart';
import 'package:vendx/utlis/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${user?.username}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${user?.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Phone: +1234567890',
              style: TextStyle(fontSize: 18),
            ),
            const Spacer(),
            CustomAuthButton(
              labelText: 'Log out',
              isDisabled: authProvider.isLoading,
              isLoading: authProvider.isLoading,
              backgroundColor: VendxColors.error700,
              onPress: () {
                authProvider.logout();
                AppRouter.go(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
