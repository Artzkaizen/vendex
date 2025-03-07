import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:vendx/features/auth/controller/auth_http.dart';
import 'package:vendx/features/cart/controller/cart_state.dart';
import 'package:vendx/features/orders/model/order.dart';

import 'package:vendx/router/routes.dart';
import 'package:vendx/utlis/constants/env.dart';
import 'package:vendx/utlis/helpers/currency_formatter.dart';

import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  final controller = Get.find<CartState>();
  late TabController _tabController;
  late Future<List<OrderModel>> _ordersFuture;
  List<OrderModel>? _currentOrders;
  Timer? _refreshTimer;
  bool _isInitialLoad = true;

  final List<String> _orderStatuses = [
    'All',
    'Paid',
    'Processing',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders(context);
    _tabController = TabController(length: _orderStatuses.length, vsync: this);

    _ordersFuture.then((orders) {
      _currentOrders = orders;
      _startRefreshTimer();
    });
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _refreshOrdersQuietly();
    });
  }

  Future<void> _refreshOrdersQuietly() async {
    try {
      final newOrders = await fetchOrders(context);
      if (mounted) {
        setState(() {
          _currentOrders = newOrders;
        });
      }
    } catch (e) {
      debugPrint('Background refresh error: $e');
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<List<OrderModel>> fetchOrders(BuildContext context) async {
    try {
      final authClient = AuthHttpClient(http.Client(), context);

      final response = await authClient.get(Uri.parse(
          '${Env.apiBaseUrl}/api/orders?populate=items&populate=items.price&populate=items.product&populate=items.product.price&populate=items.product.images&populate=items.product.category&populate=items.product.tags'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);
        return (res['data'] as List?)
                ?.map(
                    (json) => OrderModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            [];
      } else {
        final Map<String, dynamic> res = json.decode(response.body);
        debugPrint('Failed to load orders, Status: $res');
        throw Exception(
            'Failed to load orders, Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on http.ClientException catch (e) {
      throw Exception('HTTP error: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabAlignment: TabAlignment.center,
              tabs: _orderStatuses.map((status) => Tab(text: status)).toList(),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _isInitialLoad ? _ordersFuture : null,
        builder: (context, snapshot) {
          // Initial loading state
          if (_isInitialLoad &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (_isInitialLoad && snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<OrderModel> allOrders = _currentOrders ?? snapshot.data ?? [];

          if (_isInitialLoad && allOrders.isNotEmpty) {
            _isInitialLoad = false;
          }

          if (allOrders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final Map<String, List<OrderModel>> ordersByStatus = {
            'All': allOrders,
            'Paid': [],
            'Processing': [],
            'Completed': [],
            'Cancelled': [],
          };

          for (var status in _orderStatuses.where((s) => s != 'All')) {
            switch (status) {
              case 'Paid':
                ordersByStatus[status] = allOrders
                    .where((order) => order.orderStatus == "PAID")
                    .toList();
              case 'Processing':
                ordersByStatus[status] = allOrders
                    .where((order) =>
                        order.orderStatus == "PARTIALLY_COMPLETED" ||
                        order.orderStatus == "PICKUP")
                    .toList();
                break;
              case 'Completed':
                ordersByStatus[status] = allOrders
                    .where((order) => order.orderStatus == "COMPLETED")
                    .toList();
                break;
              case 'Cancelled':
                ordersByStatus[status] = allOrders
                    .where((order) => order.orderStatus == "CANCELLED")
                    .toList();
                break;
            }
          }

          return TabBarView(
            controller: _tabController,
            children: _orderStatuses.map((status) {
              return _buildOrdersList(ordersByStatus[status]!);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders in this category.'));
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: GestureDetector(
            onTap: () {
              if (order.orderStatus == "COMPLETED") {
                context.pushNamed(
                  AppRoutes.orderSummary,
                  extra: order,
                );
              } else if (order.orderStatus != "UNPAID") {
                context.pushNamed(
                  AppRoutes.orderDetails,
                  extra: order,
                  pathParameters: {'orderId': order.id.toString()},
                );
              } else {
                Get.snackbar(
                  'Unpaid Order',
                  'This order has not been paid for yet.',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                );
              }
            },
            child: Column(
              children: [
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID:${order.id} - ${order.orderStatus}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        'Items: ${order.items.length}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      order.items.first.product.images?.first.url ??
                          'https://picsum.photos/200/300',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrderSummaryScreen extends StatelessWidget {
  final OrderModel order;

  const OrderSummaryScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.id}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${order.orderStatus}',
            ),
            const SizedBox(height: 16),
            const Text(
              'Items:',
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    leading: Image.network(
                      item.product.images != null &&
                              item.product.images!.isNotEmpty
                          ? item.product.images![0].url
                          : 'https://via.placeholder.com/50',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(item.product.name),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text(
                      formatCurrency(
                          (item.price?.netPrice ?? 0) * item.quantity),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
