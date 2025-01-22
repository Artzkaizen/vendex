import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendx/features/cart/controller/cart_state.dart';
import 'package:vendx/features/product/model/products.dart';
import 'package:vendx/features/home/view/widgets/buy_now_btn.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/helpers/currency_formatter.dart';
import 'package:vendx/utlis/helpers/screen_utils.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel product;
  final String? category;

  final cart = Get.find<CartState>();

  ProductScreen({
    super.key,
    required this.product,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).brightness == Brightness.dark
        ? VendxColors.neutral900
        : VendxColors.primary50;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text('Product Details'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.favorite_outline),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: VendxScreenUtils.height(40),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://picsum.photos/200/300',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(
                          formatCurrency(double.parse(product.price)),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Product Description',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    SafeArea(
                      child: Obx(() {
                        return BuyNowButton(
                          quantity: cart.getItemQuantity(product),
                          onBuyNow: () {
                            cart.manageItem(product, 'add');
                          },
                          onAddQuantity: () {},
                        );
                      }),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
