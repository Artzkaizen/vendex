import 'package:flutter/material.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/helpers/currency_formatter.dart';

class ProductList extends StatelessWidget {
  final OrderModel order;
  final int selectedTabIndex;
  final Set<int> selectedProducts;
  final Function(int, bool) onProductSelected;

  const ProductList({
    super.key,
    required this.order,
    required this.selectedTabIndex,
    required this.selectedProducts,
    required this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: order.items.length,
      itemBuilder: (context, index) {
        final orderItem = order.items[index];
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: Image.network(
              orderItem.product.images != null &&
                      orderItem.product.images!.isNotEmpty
                  ? orderItem.product.images![0].url
                  : 'https://via.placeholder.com/50',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(orderItem.product.name),
            subtitle: Text('Qty: ${orderItem.quantity}'),
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
                : Text(formatCurrency(orderItem.product.price.netPrice)),
          ),
        );
      },
    );
  }
}
