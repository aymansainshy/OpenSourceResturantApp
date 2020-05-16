import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../provider/orders.dart';
import '../provider/carts.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context);

    return Column(
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total :',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'ORDER NOW',
                          style: TextStyle(fontSize: 16),
                        ),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (cart.items.isEmpty) {
                      return;
                    }
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await Provider.of<Orders>(context, listen: false)
                          .addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      setState(() {
                        isLoading = false;
                      });
                      cart.clear();
                      // print(Provider.of<Orders>(context, listen: false).orders);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.black54,
                        content: Text('You order is Done!'),
                        duration: Duration(seconds: 1),
                      ));
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.black54,
                        content: Text('Somthing went wrong try later!'),
                        duration: Duration(seconds: 1),
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => CartItem(
              mealId: cart.items.keys.toList()[i],
              id: cart.items.values.toList()[i].id,
              title: cart.items.values.toList()[i].title,
              quantity: cart.items.values.toList()[i].quantity,
              price: cart.items.values.toList()[i].price,
              imageUrl: cart.items.values.toList()[i].imageUrl,
            ),
          ),
        ),
      ],
    );
  }
}
