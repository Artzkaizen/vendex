import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vendx/features/product/model/product.dart';
import 'package:vendx/router/routes.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/constants/env.dart';
import 'package:vendx/utlis/constants/images.dart';
import 'package:vendx/utlis/helpers/currency_formatter.dart';

class ProductItemCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;

  const ProductItemCard({
    super.key,
    required this.onAddToCart,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.product,
          extra: product, pathParameters: {'id': product.id.toString()}),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: VendxColors.primary900,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(50),
              blurRadius: 10.0,
              spreadRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: (product.images?.isEmpty ?? true)
                      ? const AssetImage(VendxImages.imgPlaceholder)
                      : NetworkImage(
                          '${product.images?.first.url}',
                        ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.labelSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatCurrency(product.price.netPrice),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Container(
                                height: 32,
                                width: 32,
                                decoration: const BoxDecoration(
                                  color: VendxColors.primary900,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: onAddToCart,
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
