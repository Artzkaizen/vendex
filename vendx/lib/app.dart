import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendx/router/init.dart';
import 'package:vendx/utlis/helpers/screen_utils.dart';

import 'package:vendx/utlis/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    VendxScreenUtils().init(context);
    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => GetMaterialApp(
        title: 'Vendx',
        theme: VendxAppTheme.light,
        themeMode: ThemeMode.system,
        darkTheme: VendxAppTheme.dark,
        home: child,
      ),
    );
  }
}
