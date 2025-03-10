import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:vendx/features/cart/controller/cart_state.dart';
import 'package:vendx/router/routes.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CartState instance
    final CartState cartState = Get.find<CartState>();

    return SizedBox(
        width: 50,
        child: Stack(
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.bag, size: 30),
              onPressed: () => context.pushNamed(AppRoutes.cart),
            ),
            Obx(() {
              if (cartState.totalQuantity > 0) {
                return Positioned(
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      cartState.totalQuantity.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ));
  }
}
