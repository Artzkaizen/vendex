import 'package:flutter/material.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/utlis/constants/colors.dart';

class ProductList extends StatelessWidget {
  final OrderModel order;
  final int selectedTabIndex;
  final Set<int> selectedProducts;
  final Function(int, bool) onProductSelected;

  const ProductList({
    Key? key,
    required this.order,
    required this.selectedTabIndex,
    required this.selectedProducts,
    required this.onProductSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: order.products.length,
      itemBuilder: (context, index) {
        final product = order.products[index];
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: Image.network(
              product.thumbnail,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product.title),
            subtitle: Text('Qty: ${product.quantity}'),
            trailing: selectedTabIndex == 1
                ? Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: selectedProducts.contains(index),
                      onChanged: (bool? value) {
                        onProductSelected(index, value ?? false);
                      },
                      shape: const CircleBorder(),
                      activeColor: VendxColors.primary800,
                    ),
                  )
                : Text('€${product.price.toStringAsFixed(2)}'),
          ),
        );
      },
    );
  }
}
