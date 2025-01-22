import 'package:flutter/material.dart';

import 'package:vendx/config/routes/app_router.dart';
import 'package:vendx/utlis/constants/images.dart';
import 'package:vendx/utlis/helpers/screen_utils.dart';
import 'package:vendx/utlis/theme/elevated_button.dart';
import 'package:vendx/utlis/theme/text.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage(VendxImages.onBoarding),
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(VendxScreenUtils.width(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text('Vendx', style: VendxTextTheme.dark.displayLarge),
                    // Subtitle
                    Text(
                      'Find everything you need, all in one place.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                    ),

                    SizedBox(height: VendxScreenUtils.height(4)),

                    // Shop Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            AppRouter.go(context, AppRoutes.signup),
                        style: VendxElevatedButton.light.style,
                        child: Text(
                          'Shop Now',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                        ),
                      ),
                    ),

                    SizedBox(height: VendxScreenUtils.height(2)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
