import 'package:flutter/material.dart';
import 'package:vendx/features/orders/model/order.dart';
// import 'package:vendx/features/orders/model/order_strapi.dart';

import 'package:vendx/features/orders/view/widgets/order_steps.dart';
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
  int selectedTabIndex = 0; // 0 for "Redeem all", 1 for "Cherry Pick"
  Set<int> selectedProducts = {}; // Track selected products in Cherry Pick mode

  final List<Map<String, dynamic>> machines = [
    {"name": "Machine 1", "isAvailable": true},
    {"name": "Machine 2", "isAvailable": false},
    {"name": "Machine 3", "isAvailable": true},
    {"name": "Machine 4", "isAvailable": true},
  ];

  void nextStep() {
    if (currentStep < 4 && canProceed) {
      setState(() {
        currentStep++;
      });
    }
  }

  bool get canProceed {
    if (currentStep == 2) {
      final selectedMachineData = machines.firstWhere(
        (machine) => machine['name'] == selectedMachine,
        orElse: () => {"name": "", "isAvailable": false},
      );
      return selectedMachine != null && selectedMachineData['isAvailable'];
    }
    // In Cherry Pick mode, require at least one product selection
    if (selectedTabIndex == 1) {
      return selectedProducts.isNotEmpty;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: currentStep / 4,
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
              '$currentStep / 4 ${[
                "Review Details",
                "Select Machine",
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
      body: Padding(
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
                machines: machines,
                order: widget.order,
                onMachineSelected: (value) {
                  setState(() {
                    selectedMachine = value;
                  });
                },
                onTabSelected: (index) {
                  setState(() {
                    selectedTabIndex = index;
                    if (index == 0) {
                      selectedProducts.clear();
                    }
                  });
                },
                onProductSelected: (index, isSelected) {
                  setState(() {
                    if (isSelected) {
                      selectedProducts.add(index);
                    } else {
                      selectedProducts.remove(index);
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButtonTheme(
                      data: Theme.of(context).brightness == Brightness.light
                          ? VendxElevatedButton.light
                          : VendxElevatedButton.dark,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButtonTheme(
                      data: Theme.of(context).brightness == Brightness.light
                          ? VendxElevatedButton.light
                          : VendxElevatedButton.dark,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: canProceed ? nextStep : null,
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
