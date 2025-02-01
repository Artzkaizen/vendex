import 'dart:math';

class OrderModel {
  final int id;
  final List<Product> products;
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;

  OrderModel({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  // Factory constructor to create an instance from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      products: (json['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
      total: json['total'].toDouble(),
      discountedTotal: json['discountedTotal'].toDouble(),
      userId: json['userId'],
      totalProducts: json['totalProducts'],
      totalQuantity: json['totalQuantity'],
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((product) => product.toJson()).toList(),
      'total': total,
      'discountedTotal': discountedTotal,
      'userId': userId,
      'totalProducts': totalProducts,
      'totalQuantity': totalQuantity,
    };
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final int quantity;
  final int collected;
  final double total;
  final double discountPercentage;
  final double discountedTotal;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    this.collected = 0,
    required this.total,
    required this.discountPercentage,
    required this.discountedTotal,
    required this.thumbnail,
  });

  // Factory constructor to create an instance from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      total: json['total'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
      discountedTotal: json['discountedTotal'].toDouble(),
      thumbnail: json['thumbnail'],
      collected: Random().nextInt(json['quantity']),
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'quantity': quantity,
      'total': total,
      'discountPercentage': discountPercentage,
      'discountedTotal': discountedTotal,
      'thumbnail': thumbnail,
      'collected': collected
    };
  }
}
