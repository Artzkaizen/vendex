import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:vendx/features/cart/controller/cart_state.dart';
import 'package:vendx/features/product/model/products.dart';
import 'package:vendx/features/home/view/widgets/buy_now_btn.dart';
import 'package:vendx/router/routes.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/constants/env.dart';
import 'package:vendx/utlis/constants/images.dart';
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

    final List<String> imageUrls =
        product.images?.map((image) => Env.apiBaseUrl + image.url).toList() ??
            [];

    debugPrint('ProductScreen: imageUrls: $imageUrls');

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
            SizedBox(
              height: VendxScreenUtils.height(40),
              child: PageView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return (imageUrls.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(VendxImages.imgPlaceholder),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ));
                },
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
                      color: Colors.grey.withValues(alpha: 0.1),
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
                        Flexible(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.displaySmall,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        Text(
                          formatCurrency(product.price.netPrice),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Description',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              product.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 2.0),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Obx(() {
                        return BuyNowButton(
                          quantity: cart.getItemQuantity(product),
                          onBuyNow: () {
                            cart.manageItem(product, 'add');
                            context.pushNamed(Routes.cartPage);
                          },
                          onAddQuantity: () {},
                        );
                      }),
                    ),
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
