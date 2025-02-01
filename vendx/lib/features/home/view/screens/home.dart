import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:vendx/features/home/view/widgets/cart_badge.dart';
import 'package:vendx/features/product/model/products.dart';
import 'package:vendx/features/home/view/screens/main.dart';
import 'package:vendx/features/product/view/widgets/product_grid.dart';

import 'package:vendx/router/routes.dart';
import 'package:vendx/utlis/helpers/screen_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                child: Text('Vendx',
                    style: Theme.of(context).textTheme.displayMedium),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.search, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.bell, size: 30),
                    onPressed: () {},
                  ),
                  const CartBadge()
                ],
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Categories',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              SizedBox(height: VendxScreenUtils.height(2)),
              CategoriesList(),
              SizedBox(height: VendxScreenUtils.height(2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Products',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () =>
                        context.pushNamed(Routes.products, extra: ProductModel),
                    child: Text(
                      'View all',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              const ProductGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
