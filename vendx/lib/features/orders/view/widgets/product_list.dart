import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendx/features/auth/controller/auth_http.dart';
import 'package:vendx/features/orders/model/machine.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/features/orders/model/pickup.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/constants/env.dart';
import 'package:vendx/utlis/helpers/currency_formatter.dart';

class ProductList extends StatefulWidget {
  final OrderModel order;
  final int selectedTabIndex;
  final Map<String, int> selectedProducts;
  final MachineModel? machine;
  final Function(String, bool, int) onProductSelected;

  const ProductList({
    super.key,
    required this.order,
    required this.machine,
    required this.selectedTabIndex,
    required this.selectedProducts,
    required this.onProductSelected,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool isLoading = false;
  String? error;
  List<Pickup> pickups = [];
  Pickup? pickup;

  @override
  void initState() {
    super.initState();
    fetchPickups();
  }

  Future<void> fetchPickups() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final authClient = AuthHttpClient(http.Client(), context);
      final response = await authClient.get(Uri.parse(
          '${Env.apiBaseUrl}/api/pickups?populate=items&populate=order.items&populate=order.items.product&populate=order.items.product.price'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = jsonDecode(response.body);
        setState(() {
          pickups = (res['data'] as List?)
                  ?.map((json) => Pickup.fromJson(json))
                  .toList() ??
              [];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load pickups: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  int calculateCollectedQuantity(String orderId) {
    final p = pickups.where((pickup) => pickup.order.documentId == orderId);

    final collectedQuantity = p.fold<int>(0, (previousValue, element) {
      return previousValue +
          element.items.fold<int>(0, (previousValue, element) {
            return previousValue + element.shipped;
          });
    });

    return collectedQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.order.items.length,
      itemBuilder: (context, index) {
        final orderItem = widget.order.items[index];
        final collected = calculateCollectedQuantity(widget.order.documentId);

        debugPrint('collected: $collected');

        final stock = widget.machine?.stocks
            .cast<Stock>()
            .where((stock) =>
                stock.product?.documentId == orderItem.product.documentId)
            .firstOrNull;

        // Check if all items have been collected
        final bool isFullyCollected = collected >= orderItem.quantity ||
            stock?.quantity == 0 ||
            stock?.quantity == null;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: isFullyCollected ? Colors.grey[200] : null,
          child: ListTile(
            enabled: !isFullyCollected,
            leading: Image.network(
              orderItem.product.images != null &&
                      orderItem.product.images!.isNotEmpty
                  ? orderItem.product.images![0].url
                  : 'https://via.placeholder.com/50',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              opacity:
                  isFullyCollected ? const AlwaysStoppedAnimation(0.5) : null,
            ),
            title: Text(
              orderItem.product.name,
              style: TextStyle(
                color: isFullyCollected ? Colors.grey : null,
              ),
            ),
            subtitle: Text(
              'Qty: ${orderItem.quantity} | Collected: $collected',
              style: TextStyle(
                color: isFullyCollected ? Colors.grey : null,
              ),
            ),
            trailing: widget.selectedTabIndex == 1
                ? Transform.scale(
                    scale: 1,
                    child: Checkbox(
                      value: widget.selectedProducts
                          .containsKey(orderItem.product.documentId),
                      onChanged: isFullyCollected
                          ? null
                          : (bool? value) {
                              widget.onProductSelected(
                                  orderItem.product.documentId,
                                  value ?? false,
                                  orderItem.quantity - collected);
                            },
                      shape: const CircleBorder(),
                      activeColor: VendxColors.primary800,
                    ),
                  )
                : Text(
                    formatCurrency(orderItem.product.price?.netPrice ?? 0),
                    style: TextStyle(
                      color: isFullyCollected ? Colors.grey : null,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
