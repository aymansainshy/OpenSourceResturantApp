import 'package:flutter/cupertino.dart';
import '../model/cart.dart';

class Carts with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return Map.from(_items);
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
        (key, cartItem) => total += cartItem.price * cartItem.quantity);
    return total;
  }

  void addItem(String mealId, double price, String title, String imageUrl) {
    if (_items.containsKey(mealId)) {
      _items.update(
        mealId,
        (existingCartItem) => Cart(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        mealId,
        () => Cart(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }


//Remove item from cartItems
  void removeItem(String mealId) {
    _items.remove(mealId);
    notifyListeners();
  }

//Reset _items after Order Done !
  void clear() {
    _items = {};
    notifyListeners();
  }


//UNDO add item to the cart
  void removeSingleItem(String mealId) {
    if (!_items.containsKey(mealId)) {
      return;
    }
    if (_items[mealId].quantity > 1) {
      _items.update(
        mealId,
        (existingCartItem) => Cart(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.remove(mealId);
    }
    notifyListeners();
  }
}
