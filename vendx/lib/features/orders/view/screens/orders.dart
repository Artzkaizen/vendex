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

// class Order {
//   final int id;
//   final String orderStatus;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime publishedAt;
//   final List<OrderItem> items;

//   Order({
//     required this.id,
//     required this.orderStatus,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.publishedAt,
//     required this.items,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: json['id'],
//       orderStatus: json['orderStatus'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       publishedAt: DateTime.parse(json['publishedAt']),
//       items: (json['items'] as List)
//           .map((item) => OrderItem.fromJson(item))
//           .toList(),
//     );
//   }
// }

// class OrderItem {
//   final int id;
//   final int quantity;
//   final Product product;
//   final Price price;

//   OrderItem({
//     required this.id,
//     required this.quantity,
//     required this.product,
//     required this.price,
//   });

//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       id: json['id'],
//       quantity: json['quantity'],
//       product: Product.fromJson(json['product']),
//       price: Price.fromJson(json['price']),
//     );
//   }
// }

// class Product {
//   final int id;
//   final String documentId;
//   final String name;
//   final String description;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime publishedAt;
//   final String productStatus;

//   Product({
//     required this.id,
//     required this.documentId,
//     required this.name,
//     required this.description,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.publishedAt,
//     required this.productStatus,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       documentId: json['documentId'],
//       name: json['name'],
//       description: json['description'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       publishedAt: DateTime.parse(json['publishedAt']),
//       productStatus: json['productStatus'],
//     );
//   }
// }

// class Price {
//   final int id;
//   final double netPrice;
//   final String currency;
//   final double vatRate;

//   Price({
//     required this.id,
//     required this.netPrice,
//     required this.currency,
//     required this.vatRate,
//   });

//   factory Price.fromJson(Map<String, dynamic> json) {
//     return Price(
//       id: json['id'],
//       netPrice: json['netPrice'].toDouble(),
//       currency: json['currency'],
//       vatRate: json['vatRate'].toDouble(),
//     );
//   }
// }

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final controller = Get.find<CartState>();

  Future<List<OrderModel>> fetchProducts(BuildContext context) async {
    try {
      final authClient = AuthHttpClient(http.Client(), context);

      final response = await authClient.get(Uri.parse(
          '${Env.apiBaseUrl}/api/orders?populate=items&populate=items.price&populate=items.product&populate=items.product.price&populate=items.product.images&populate=items.product.category&populate=items.product.tags'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);

        debugPrint('Orders: ${res}');

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
      // Handle network issues like no internet
      throw Exception('No internet connection');
    } on http.ClientException catch (e) {
      // Handle HTTP client issues
      throw Exception('HTTP error: $e');
    } catch (e) {
      // Handle any other unexpected errors
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: FutureBuilder<List<OrderModel>>(
        future: fetchProducts(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there's an error, show the error message
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If no data, display a message
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: GestureDetector(
                  onTap: () => context.pushNamed(
                    AppRoutes.orderDetails,
                    extra: order,
                    pathParameters: {'orderId': order.id.toString()},
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Code: ${order.id}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              'Items: items',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
