import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vendx/features/auth/controller/auth_http.dart';
import 'package:vendx/features/orders/model/pickup.dart';
import 'package:vendx/features/orders/view/widgets/order_steps.dart';
import 'package:vendx/utlis/constants/env.dart';
import 'package:vendx/utlis/theme/elevated_button.dart';

class PickupInit {
  final String documentId;
  final String progress;

  PickupInit({
    this.documentId = '',
    this.progress = 'pending',
  });
  factory PickupInit.fromJson(Map<String, dynamic> json) {
    return PickupInit(
      documentId: json['documentId'],
      progress: json['progress'],
    );
  }
}

class PickupSuccessScreen extends StatefulWidget {
  final String orderId;
  final PickupProgress data;

  const PickupSuccessScreen(
      {super.key, required this.orderId, required this.data});

  @override
  State<PickupSuccessScreen> createState() => _PickupSuccessScreenState();
}

class _PickupSuccessScreenState extends State<PickupSuccessScreen> {
  PickupInit? _pickupInit;
  bool _isPolling = false;
  bool _pollCompleted = false;
  String? _error;
  Timer? _pollingTimer;
  bool _isLoadingQR = true;

  int _pickupStatus = 0; // 0: pending, 1: started, 2: finished

  @override
  void initState() {
    super.initState();
    _initializePickup();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializePickup() async {
    try {
      final pickupInit = await startPickUp(widget.orderId, context);

      if (mounted) {
        setState(() {
          _pickupInit = pickupInit;
          _isLoadingQR = false;
          _pickupStatus = 0;
        });

        _startPolling(pickupInit.documentId);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoadingQR = false;
        });
      }
    }
  }

  Future<PickupInit> startPickUp(String orderId, BuildContext context) async {
    final authClient = AuthHttpClient(http.Client(), context);

    debugPrint('Starting Pickup for Order: $orderId');
    try {
      final response = await authClient.post(
        Uri.parse('${Env.apiBaseUrl}/api/orders/$orderId/start-pickup'),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> res = jsonDecode(response.body);

        return PickupInit.fromJson(res['data']);
      } else {
        throw Exception('Failed to Start Pickup: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in startPickUp: $e');
      Get.snackbar(
        'Failed to Start Pickup',
        'Pickup already started for this order.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );

      throw Exception('Failed to start pickup: $e');
    }
  }

  void _startPolling(String pickupId) {
    setState(() {
      _isPolling = true;
    });
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        // Get the current status from the machine
        final status = await pollPickupStatus(pickupId);
        if (!mounted) return;
        setState(() {
          _pickupStatus = status;
        });
        // Once finished, stop polling
        if (status == 2) {
          timer.cancel();
          setState(() {
            _pollCompleted = true;
            _isPolling = false;
          });
        }
      } catch (e) {
        debugPrint('Error polling pickup status: $e');
        if (mounted && _pollingTimer != null && _pollingTimer!.tick > 5) {
          timer.cancel();
          setState(() {
            _error = 'Polling error: ${e.toString()}';
            _isPolling = false;
          });
        }
      }
    });
  }

  Future<int> pollPickupStatus(String pickupId) async {
    try {
      if (!mounted) return 0;
      final authClient = AuthHttpClient(http.Client(), context);
      final response = await authClient.get(Uri.parse(
          '${Env.apiBaseUrl}/api/pickups/$pickupId?populate=order.items.product&populate=items.product'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);
        final pickup = Pickup.fromJson(res['data'] as Map<String, dynamic>);
        return switch (pickup.progress) {
          'pending' => 0,
          'started' => 1,
          'finished' => 2,
          _ => -1
        };
      } else {
        throw Exception('Failed to poll pickup status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in pollPickupStatus: $e');
      throw Exception('Error polling pickup status: $e');
    }
  }

  Future<void> updatePickStatus(String pickupId, BuildContext context) async {
    final authClient = AuthHttpClient(http.Client(), context);
    try {
      final response = await authClient.put(
        Uri.parse('${Env.apiBaseUrl}/api/pickups/$pickupId'),
        body: json.encode({
          "data": {
            "progress": "finished",
            "items": widget.data.items
                .map((item) => {"id": item.id, "progress": "finished"})
                .toList()
          }
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> res = jsonDecode(response.body);
        debugPrint('End Pickup Response: $res');
      } else {
        throw Exception('Failed to End Pickup: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in updatePickStatus: $e');
      throw Exception('Failed to end pickup: $e');
    }
  }

  // Future<int> pollPickupStatus(String pickupId) async {
  //   // Simulate network delay
  //   await Future.delayed(const Duration(milliseconds: 500));

  //   // Mock progression based on polling timer ticks
  //   if (!mounted) return 0;

  //   // Simulate status changes based on time
  //   if (_pollingTimer == null) return 0;

  //   if (_pollingTimer!.tick < 3) {
  //     return 0; // pending for first 3 seconds
  //   } else if (_pollingTimer!.tick < 6) {
  //     return 1;
  //   } else {
  //     return 2;
  //   }
  // }

  Widget _buildPickupStepper() {
    return Stepper(
      physics: const ClampingScrollPhysics(),
      currentStep: _pickupStatus,
      steps: [
        Step(
          title: const Text("Pickup Pending"),
          content: const Align(
            alignment: Alignment.centerLeft,
            child: Text("Waiting for the machine to start."),
          ),
          isActive: _pickupStatus >= 0,
          state: _pickupStatus > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text("Pickup Started"),
          content: const Align(
            alignment: Alignment.centerLeft,
            child: Text("Machine has started the pickup process."),
          ),
          isActive: _pickupStatus >= 1,
          state: _pickupStatus > 1
              ? StepState.complete
              : _pickupStatus == 1
                  ? StepState.editing
                  : StepState.indexed,
        ),
        Step(
          title: const Text("Pickup Finished"),
          content: const Align(
            alignment: Alignment.centerLeft,
            child: Text("Your Pickup is complete."),
          ),
          isActive: _pickupStatus >= 2,
          state: _pickupStatus == 2 ? StepState.complete : StepState.indexed,
        ),
      ],
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                    _isLoadingQR = true;
                  });
                  _initializePickup();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoadingQR) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Preparing QR code...")
          ],
        ),
      );
    }

    final infoText = _pickupStatus == 0
        ? 'Present this QR code to the machine to pickup your order.'
        : _pickupStatus == 1
            ? "Please Pickup your items from the machine.\nDon't forget to close the door 😉"
            : 'THANK YOU!\nYour order has been picked up successfully.';

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: QrImageView(
              data: _pickupInit!.documentId,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          Text(
            infoText,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _buildPickupStepper(),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
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
                onPressed: _pickupStatus == 2
                    ? () {
                        GoRouter.of(context).go('/orders');
                      }
                    : null,
                child: const Text('Finish'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
