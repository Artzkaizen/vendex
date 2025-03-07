import 'package:vendx/features/product/model/price.dart';
import 'package:vendx/features/product/model/product.dart';

class OrderModel {
  final int id;
  final String documentId;
  final String orderStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.documentId,
    required this.orderStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      documentId: json['documentId'],
      orderStatus: json['orderStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final int id;
  final int quantity;
  final ProductModel product;
  final Price? price;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.product,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      quantity: json['quantity'],
      product: ProductModel.fromJson(json['product']),
      price: json['price'] != null ? Price.fromJson(json['price']) : null,
    );
  }
}

class Meta {
  final Pagination pagination;

  Meta({
    required this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination.toJson(),
    };
  }
}

class Pagination {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'pageCount': pageCount,
      'total': total,
    };
  }
}
