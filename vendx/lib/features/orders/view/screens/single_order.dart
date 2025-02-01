import 'package:flutter/material.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/theme/elevated_button.dart';

class SingleOrderScreen extends StatefulWidget {
  final OrderModel order;

  const SingleOrderScreen({super.key, required this.order});

  @override
  _SingleOrderScreenState createState() => _SingleOrderScreenState();
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

  bool get canProceed {
    if (currentStep == 2) {
      // Check if selected machine exists and is available
      final selectedMachineData = machines.firstWhere(
        (machine) => machine['name'] == selectedMachine,
        orElse: () => {"name": "", "isAvailable": false},
      );
      return selectedMachine != null && selectedMachineData['isAvailable'];
    }
    return true;
  }

  void nextStep() {
    if (currentStep < 4 && canProceed) {
      setState(() {
        currentStep++;
      });
    }
  }

  void cancelOrder() {
    setState(() {
      currentStep = 1;
      selectedMachine = null;
    });
  }

  Widget renderStepContent() {
    switch (currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Products',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (context, index) {
                  final product = widget.order.products[index];

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
                      subtitle: Text(
                          'Collected: ${product.collected} of ${product.quantity}'),
                      trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Machine',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMachine,
              hint: const Text("Choose a machine"),
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
              onChanged: (value) {
                setState(() {
                  selectedMachine = value;
                });
              },
              isExpanded: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(10),
                errorText: selectedMachine != null && !canProceed
                    ? 'Selected machine is not available'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            if (selectedMachine != null && canProceed)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Machine ready: $selectedMachine',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Order',
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
                    Text('Total Items: ${widget.order.products.length}'),
                    const SizedBox(height: 8),
                    Text(
                      'Total Amount: \$${widget.order.products.fold(0.0, (sum, product) => sum + (product.price * product.quantity)).toStringAsFixed(2)}',
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
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: VendxColors.primary300,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guidelines',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Review Details'),
                  Text('2. Select a Machine'),
                  Text('3. Confirm or Cancel'),
                  Text('4. Get Help if Needed'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: renderStepContent()),
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
                        onPressed: cancelOrder,
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
