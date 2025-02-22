import 'package:flutter/material.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/features/orders/view/widgets/order_tabs.dart';
import 'package:vendx/features/orders/view/widgets/product_list.dart';

class StepContent extends StatelessWidget {
  final int currentStep;
  final String? selectedMachine;
  final int selectedTabIndex;
  final Set<int> selectedProducts;
  final List<Map<String, dynamic>> machines;
  final OrderModel order;
  final Function(String?) onMachineSelected;
  final Function(int) onTabSelected;
  final Function(int, bool) onProductSelected;

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
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderTabs(
              selectedTabIndex: selectedTabIndex,
              onTabSelected: onTabSelected,
            ),
            const SizedBox(height: 20),
            Text(
              'Select Machine',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedMachine,
                hint: const Text("Select a machine"),
                items: machines.map((machine) {
                  final bool isAvailable = machine['isAvailable'];
                  return DropdownMenuItem<String>(
                    value: machine['name'],
                    enabled: isAvailable,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          machine['name'],
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
                onChanged: onMachineSelected,
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
                order: order,
                selectedTabIndex: selectedTabIndex,
                selectedProducts: selectedProducts,
                onProductSelected: onProductSelected,
              ),
            ),
            if (selectedTabIndex == 1) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
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
                      '${selectedProducts.length} / ${order.items.length}',
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
              'Select Machine',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedMachine,
                hint: const Text("Select a machine"),
                items: machines.map((machine) {
                  final bool isAvailable = machine['isAvailable'];
                  return DropdownMenuItem<String>(
                    value: machine['name'],
                    enabled: isAvailable,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          machine['name'],
                          style: TextStyle(
                            color: isAvailable ? null : Colors.grey,
                          ),
                        ),
                        if (isAvailable)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
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
                onChanged: onMachineSelected,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Machine: $selectedMachine'),
                    const SizedBox(height: 8),
                    Text(
                      'Items: ${selectedTabIndex == 1 ? selectedProducts.length : order.items.length}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 4:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text(
                'Order Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
