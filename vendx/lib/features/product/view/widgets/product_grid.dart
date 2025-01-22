import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vendx/features/cart/controller/cart_state.dart';

import 'package:vendx/features/product/model/products.dart';
import 'package:vendx/features/product/view/widgets/product_item_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  Future<List<ProductModel>> fetchProducts() async {
    final response =
        await http.get(Uri.parse("http://localhost:4000/products"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cart = CartContext.of(context);

    return FutureBuilder(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            final List<ProductModel> products = snapshot.data!;
            return Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.9,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ProductItemCard(
                    product: products[index],
                    onAddToCart: () {
                      final CartState cartState = Get.find<CartState>();

                      // Add item to the cart
                      cartState.manageItem(products[index], "add");
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
