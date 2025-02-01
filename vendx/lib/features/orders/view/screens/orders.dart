import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:vendx/features/cart/controller/cart_state.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/router/routes.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final controller = Get.find<CartState>();

  Future<List<OrderModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("https://dummyjson.com/carts"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return (data['carts'] as List)
            .map((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on http.ClientException catch (e) {
      throw Exception('ClientException: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: FutureBuilder<List<OrderModel>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: GestureDetector(
                    onTap: () =>
                        context.pushNamed(Routes.orderDetails, extra: order),
                    child: Column(
                      children: [
                        ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order Code: ${order.id}",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              Text('item',
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              const SizedBox(height: 20),
                            ],
                          ),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              'https://picsum.photos/200/300',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
