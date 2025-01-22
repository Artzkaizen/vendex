import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:vendx/features/auth/view/widgets/button.dart';
import 'package:vendx/features/cart/controller/cart_state.dart';
import 'package:vendx/features/cart/view/screens/add_remove_cart.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/helpers/currency_formatter.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final controller = Get.find<CartState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: Obx(() {
          final items = controller.items;
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 20),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          TProductQuantityWithAddRemoveButton(
                            width: 32,
                            height: 32,
                            iconSize: 16,
                            addBackgroundColor: VendxColors.primary900,
                            removeForegroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            removeBackgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[800]!
                                    : Colors.white,
                            quantity: item.quantity,
                            add: () =>
                                controller.manageItem(item.product, 'add'),
                            remove: () =>
                                controller.manageItem(item.product, 'remove'),
                          ),
                          const Spacer(),
                          Text(formatCurrency(double.parse(item.product.price)),
                              style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          'https://picsum.photos/200/300',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                              formatCurrency(double.parse(
                                  controller.getTotalAmount().toString())),
                              style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // const CheckoutScreen(),

                      CustomAuthButton(
                          isLoading: controller.isCheckoutPending,
                          isDisabled: controller.isEmpty ||
                              controller.isCheckoutPending,
                          labelText: 'Checkout',
                          onPress: () => controller.handleCheckout(context))
                    ],
                  )),
            )));
  }
}
