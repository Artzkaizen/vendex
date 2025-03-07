import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/features/product/model/product.dart';

class PickupItem {
  final int id;
  final int shipped;
  final int required;
  final ProductModel? product;

  PickupItem({
    required this.id,
    required this.shipped,
    required this.required,
    this.product,
  });

  factory PickupItem.fromJson(Map<String, dynamic> json) {
    return PickupItem(
      id: json['id'],
      shipped: json['shipped'],
      required: json['required'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }
}

class Pickup {
  final int id;
  final String documentId;
  final String progress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final OrderModel order;
  final List<PickupItem> items;

  Pickup({
    required this.id,
    required this.documentId,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.order,
    required this.items,
  });

  factory Pickup.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<PickupItem> items =
        itemsList.map((i) => PickupItem.fromJson(i)).toList();

    return Pickup(
      id: json['id'],
      documentId: json['documentId'],
      progress: json['progress'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
      order: OrderModel.fromJson(json['order']),
      items: items,
    );
  }
}
