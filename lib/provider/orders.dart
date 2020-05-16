import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/cart.dart';
import '../model/order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<Order> get orders {
    return List.from(_orders);
  }



    static const String firebaseAppUrl = 'firebaseAppUrl';

  Future<void> fetchAndSetOrders() async {
    final url =
        '$firebaseAppUrl/userOrders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      if (loadedData == null) {
        return;
      }
      final List<Order> loadedOrder = [];

      loadedData.forEach((orderKey, orderData) {
        loadedOrder.add(Order(
          id: orderKey,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          meals: (orderData['meals'] as List<dynamic>)
              .map(
                (mCart) => Cart(
                  id: mCart['id'],
                  title: mCart['title'],
                  quantity: mCart['quantity'],
                  price: mCart['price'],
                  imageUrl: mCart['imageUrl'],
                ),
              )
              .toList(),
        ));
      });
      _orders = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<Cart> cartMeals, double total) async {
    final url =
        '$firebaseAppUrl/userOrders/$userId.json?auth=$authToken';
    var timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'meals': cartMeals
              .map(
                (cm) => {
                  'id': cm.id,
                  'title': cm.title,
                  'quantity': cm.quantity,
                  'price': cm.price,
                  'imageUrl': cm.imageUrl,
                },
              )
              .toList(),
        }),
      );

      _orders.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          // imageUrl: imageUrl,
          amount: total,
          meals: cartMeals,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
