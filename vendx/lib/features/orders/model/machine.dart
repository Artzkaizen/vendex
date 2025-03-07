import 'package:vendx/features/product/model/price.dart';

class MachineModel {
  final int id;
  final String? documentId;
  final String? name;
  final String? machineStatus;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final List<Stock> stocks;

  MachineModel({
    required this.id,
    required this.documentId,
    required this.name,
    required this.machineStatus,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.stocks,
  });

  factory MachineModel.fromJson(Map<String, dynamic> json) {
    return MachineModel(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      machineStatus: json['machineStatus'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
      stocks: json['stocks'] != null
          ? (json['stocks'] as List).map((i) => Stock.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'machineStatus': machineStatus,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      'stocks': stocks.map((e) => e.toJson()).toList(),
    };
  }
}

class Stock {
  final int id;
  final int quantity;
  final Product? product;

  Stock({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      quantity: json['quantity'],
      product:
          json['product'] != null ? Product?.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'product': product?.toJson(),
    };
  }
}

class Product {
  final int id;
  final String? documentId;
  final String? name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  // final String? productStatus;
  // final String? gtin;
  final Price price;

  Product({
    required this.id,
    required this.documentId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    // required this.productStatus,
    // required this.gtin,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
      // productStatus: json['productStatus'],
      // gtin: json['gtin'],
      price: Price.fromJson(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      // 'productStatus': productStatus,
      // 'gtin': gtin,
      'price': price.toJson(),
    };
  }
}
