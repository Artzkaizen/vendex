import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:vendx/features/cart/controller/cart_state.dart';
import 'package:vendx/features/product/model/products.dart';
import 'package:vendx/features/product/view/widgets/product_item_card.dart';
import 'package:vendx/utlis/constants/env.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('${Env.apiBaseUrl}/api/products?populate=*'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['data'];
        return products.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on http.ClientException catch (e) {
      throw Exception('ClientException: $e');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Widget _buildLoadingState() {
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
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48.0,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Oops! Something went wrong.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductItemCard(
                    product: products[index],
                    onAddToCart: () {
                      final CartState cartState = Get.find<CartState>();

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
