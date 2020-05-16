import 'package:flutter/cupertino.dart';

import '../model/cart.dart';

class Order {
  final String id;
  // final String imageUrl;
  final double amount;
  final List<Cart> meals;
  final DateTime dateTime;

  Order({
    @required this.id,
    // @required this.imageUrl,
    @required this.amount,
    @required this.meals,
    @required this.dateTime,
  });
}
