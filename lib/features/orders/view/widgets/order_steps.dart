import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vendx/features/auth/controller/auth_http.dart';
import 'package:vendx/features/cart/view/screens/add_remove_cart.dart';
import 'package:vendx/features/orders/model/machine.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/features/orders/model/pickup.dart';
import 'package:vendx/features/orders/view/screens/pickup.dart';
import 'package:vendx/features/orders/view/widgets/order_tabs.dart';
import 'package:vendx/features/orders/view/widgets/product_list.dart';
import 'package:vendx/features/product/model/product.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/constants/env.dart';
import 'package:http/http.dart' as http;

class StepContent extends StatefulWidget {
  final int currentStep;
  final String? selectedMachine;
  final int selectedTabIndex;
  final Map<String, int> selectedProducts;
  final List<MachineModel> machines;
  final OrderModel order;
  final Function(String?) onMachineSelected;
  final Function(int) onTabSelected;
  final Function(String, bool, int) onProductSelected;

  const StepContent({
    super.key,
    required this.currentStep,
    required this.selectedMachine,
    required this.selectedTabIndex,
    required this.selectedProducts,
    required this.machines,
    required this.order,
    required this.onMachineSelected,
    required this.onTabSelected,
    required this.onProductSelected,
  });

  @override
  State<StepContent> createState() => _StepContentState();
}

class _StepContentState extends State<StepContent> {
  bool isLoading = false;
  String? error;
  List<Pickup> pickups = [];
  // Pickup? pickup;

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

  int calculateCollectedQuantity(String productId) {
    final p = pickups.where((pickup) => pickup.order.documentId == productId);

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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return buildContent(context);
  }

  Widget buildContent(BuildContext context) {
    switch (widget.currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderTabs(
              selectedTabIndex: widget.selectedTabIndex,
              onTabSelected: widget.onTabSelected,
            ),
            const SizedBox(height: 20),
            Text(
              'Select Machine',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: widget.selectedMachine,
                hint: const Text("Select a machine"),
                items: widget.machines.map((machine) {
                  final bool isAvailable = machine.machineStatus == 'ACTIVE';
                  return DropdownMenuItem<String>(
                    value: machine.name,
                    enabled: isAvailable,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          machine.name ?? '',
                          style: TextStyle(
                            color: isAvailable ? null : Colors.grey,
                          ),
                        ),
                        if (isAvailable)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                            size: 20,
                          )
                        else
                          const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 20,
                          ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: widget.onMachineSelected,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Products',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ProductList(
                order: widget.order,
                machine: widget.machines.cast<MachineModel?>().firstWhere(
                      (machine) => machine?.name == widget.selectedMachine,
                      orElse: () => null,
                    ),
                selectedTabIndex: widget.selectedTabIndex,
                selectedProducts: widget.selectedProducts,
                onProductSelected: widget.onProductSelected,
              ),
            ),
            if (widget.selectedTabIndex == 1) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Items:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${widget.selectedProducts.length} / ${widget.order.items.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selected Machine: ${widget.selectedMachine}'),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        ...widget.order.items.where((item) {
                          return widget.selectedProducts
                              .containsKey(item.product.documentId);
                        }).map((item) {
                          return QuickPickCard(
                              onAdd: () => widget.onProductSelected(
                                  item.product.documentId,
                                  true,
                                  item.quantity -
                                      calculateCollectedQuantity(
                                          item.product.documentId)),
                              onRemove: () => widget.onProductSelected(
                                  item.product.documentId,
                                  false,
                                  item.quantity -
                                      calculateCollectedQuantity(
                                          item.product.documentId)),
                              product: item.product,
                              quantity: widget.selectedProducts[
                                      item.product.documentId] ??
                                  0);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      case 3:
        return PickupSuccessScreen(
          orderId: widget.order.documentId,
          data: PickupProgress(
            progress: "finished",
            items: widget.selectedProducts.entries
                .map(
                    (entry) => PickupItem(id: entry.key, quantity: entry.value))
                .toList(),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class QuickPickCard extends StatelessWidget {
  final int quantity;
  final ProductModel product;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuickPickCard(
      {super.key,
      required this.product,
      required this.quantity,
      required this.onAdd,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 20),
              ],
            ),
            subtitle: Row(
              children: [
                const Spacer(),
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
                  quantity: quantity,
                  add: onAdd,
                  remove: onRemove,
                )
              ],
            ),
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                product.images != null && product.images!.isNotEmpty
                    ? product.images![0].url
                    : 'https://via.placeholder.com/50',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PickupProgress {
  final String progress;

  final List<PickupItem> items;

  PickupProgress({
    required this.progress,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'progress': progress,
        'items': items.map((item) => item.toJson()).toList(),
      }
    };
  }

  factory PickupProgress.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PickupProgress(
      progress: data['progress'],
      items: (data['items'] as List)
          .map((item) => PickupItem.fromJson(item))
          .toList(),
    );
  }
}

class PickupItem {
  final String id;
  final int quantity;

  PickupItem({
    required this.id,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
      };

  factory PickupItem.fromJson(Map<String, dynamic> json) {
    return PickupItem(
      id: json['id'] as String,
      quantity: json['quantity'] as int,
    );
  }
}

Future<List<Pickup>> startPickUp(String orderId, BuildContext context) async {
  try {
    final authClient = AuthHttpClient(http.Client(), context);
    final response = await authClient.get(
      Uri.parse('${Env.apiBaseUrl}/api/orders/$orderId/start-pickup'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> res = jsonDecode(response.body);
      return (res['data'] as List?)
              ?.map((json) => Pickup.fromJson(json))
              .toList() ??
          [];
    } else {
      throw Exception('Failed to Start Pickups: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('An error occurred: $e');
    throw Exception('An error occurred: $e');
  }
}
