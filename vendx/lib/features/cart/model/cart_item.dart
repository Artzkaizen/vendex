import 'package:vendx/features/product/model/product.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.quantity,
  });
}
