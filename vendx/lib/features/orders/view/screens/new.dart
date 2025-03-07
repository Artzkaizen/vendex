import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:vendx/features/auth/controller/auth_http.dart';
import 'package:vendx/features/orders/model/machine.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/features/orders/model/pickup.dart';
import 'package:vendx/features/orders/view/widgets/order_steps.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/constants/env.dart';
import 'package:vendx/utlis/theme/elevated_button.dart';

class SingleOrderScreen extends StatefulWidget {
  final OrderModel order;

  const SingleOrderScreen({super.key, required this.order});

  @override
  State<SingleOrderScreen> createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  int currentStep = 1;
  String? selectedMachine;
  int selectedTabIndex = 0;
  Map<String, int> selectedProducts = {};

  List<MachineModel>? machines;
  bool isLoading = true;
  String? pickError;
  String? errorMessage;
  List<Pickup> pickups = [];

  @override
  void initState() {
    super.initState();
    fetchPickups();
    fetchMachines();

    if (selectedTabIndex == 0) {
      for (var item in widget.order.items) {
        final remaining =
            item.quantity - calculateCollectedQuantity(item.product.documentId);
        if (remaining > 0) {
          selectedProducts[item.product.documentId] = remaining;
        }
      }
    }

    // populateAllTabs();
  }

  void populateAllTabs() {
    if (selectedMachine != null && selectedTabIndex == 0) {
      for (var item in widget.order.items) {
        final remaining =
            item.quantity - calculateCollectedQuantity(item.product.documentId);

        final machine = machines
            ?.cast<MachineModel?>()
            .where((element) => element?.name == selectedMachine)
            .firstOrNull;

        final stock = machine?.stocks.cast<Stock?>().firstWhere(
            (stock) => stock?.product?.documentId == item.product.documentId,
            orElse: () => null);
        final max = stock?.quantity ?? 0;

        if (remaining > 0 && remaining <= max) {
          selectedProducts[item.product.documentId] = remaining;
        }
      }
    }
  }

  Future<void> fetchPickups() async {
    setState(() {
      isLoading = true;
      pickError = null;
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
          pickError = 'Failed to load pickups: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        pickError = 'An error occurred: $e';
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

  Future<void> fetchMachines() async {
    try {
      final authClient = AuthHttpClient(http.Client(), context);
      final response = await authClient.get(Uri.parse(
          '${Env.apiBaseUrl}/api/vending-machines/?populate[stocks][populate][product][populate]=price'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);
        setState(() {
          machines = (res['data'] as List?)
                  ?.map((json) =>
                      MachineModel.fromJson(json as Map<String, dynamic>))
                  .toList() ??
              [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load machines: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load machines. Error: $e";
        isLoading = false;
      });
    }
  }

  void nextStep() {
    if (currentStep < 3 && canProceed()) {
      setState(() {
        currentStep++;
      });
    } else {
      GoRouter.of(context).go('/orders');
    }
  }

  bool canProceed() {
    if (currentStep == 1 || selectedTabIndex == 1) {
      return selectedMachine != null && selectedProducts.isNotEmpty;
    }

    return true;
  }

  // New methods for product selection
  void incrementProduct(String productId, int max) {
    setState(() {
      int currentCount = selectedProducts[productId] ?? 0;
      if (currentCount < max) {
        selectedProducts[productId] = currentCount + 1;
      }
    });
  }

  void decrementProduct(String productId) {
    setState(() {
      int currentCount = selectedProducts[productId] ?? 0;
      if (currentCount > 1) {
        selectedProducts[productId] = currentCount - 1;
      } else if (currentCount == 1) {
        selectedProducts.remove(productId);
      }
    });
  }

  void toggleProductSelection(String productId, int max) {
    setState(() {
      if (selectedProducts.containsKey(productId)) {
        selectedProducts.remove(productId);
      } else {
        selectedProducts[productId] = 1;
      }
    });
  }

  void handleTabChange(int index) {
    setState(() {
      selectedTabIndex = index;
      selectedProducts.clear();
      if (index == 0) {
        for (var item in widget.order.items) {
          final remaining = item.quantity -
              calculateCollectedQuantity(item.product.documentId);

          if (remaining > 0) {
            selectedProducts[item.product.documentId] = remaining;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: currentStep / 3,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Redeem Order'),
            Text(
              '$currentStep / 3 ${[
                "Review Details",
                "Confirm",
                "Complete"
              ][currentStep - 1]}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : machines == null || machines!.isEmpty
                  ? const Center(child: Text("No available machines."))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: StepContent(
                              currentStep: currentStep,
                              selectedMachine: selectedMachine,
                              selectedTabIndex: selectedTabIndex,
                              selectedProducts: selectedProducts,
                              machines: machines!,
                              order: widget.order,
                              onMachineSelected: (value) {
                                setState(() {
                                  selectedMachine = value;

                                  populateAllTabs();
                                });
                              },
                              onTabSelected: handleTabChange,
                              // Updated product selection handler
                              onProductSelected: (productId, isIncrement, max) {
                                if (isIncrement) {
                                  incrementProduct(productId, max);
                                } else {
                                  decrementProduct(productId);
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (currentStep < 3)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButtonTheme(
                                      data: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? VendxElevatedButton.light
                                          : VendxElevatedButton.dark,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade100,
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: const Text('Cancel',
                                            style: TextStyle(
                                                color: VendxColors.primary900)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButtonTheme(
                                      data: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? VendxElevatedButton.light
                                          : VendxElevatedButton.dark,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed:
                                            canProceed() ? nextStep : null,
                                        child: Text(
                                          currentStep < 4 ? 'Next' : 'Finish',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
    );
  }
}
