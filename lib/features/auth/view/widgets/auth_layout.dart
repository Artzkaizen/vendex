import 'package:flutter/material.dart';
import 'package:vendx/utlis/constants/images.dart';
import 'package:vendx/utlis/helpers/screen_utils.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  final dynamic appBarHeight = VendxScreenUtils.height(50);

  AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: appBarHeight,
                child: Image.asset(
                  VendxImages.authVendingMachine,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - appBarHeight,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
