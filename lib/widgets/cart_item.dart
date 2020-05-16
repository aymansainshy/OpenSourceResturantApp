import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/carts.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String mealId;
  final int quantity;
  final String title;
  final String imageUrl;

  CartItem({
    this.id,
    this.price,
    this.mealId,
    this.quantity,
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want remove item from the cart'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  }),
              FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  }),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // if (direction == DismissDirection.endToStart) {
        cart.removeItem(mealId);
        // }else{
        //   cart.removeSingleQuantity(mealId);
        // }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    '\$$price',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // backgroundColor: Colors.black,
                    ),
                  ),
                ),
              ],

              //   CircleAvatar(
              //   radius: 30,
              //   child: Padding(
              //     padding: const EdgeInsets.all(3),
              //     child: Stack(
              //       alignment: Alignment.center,
              //       children: <Widget>[
              //         Image.network(
              //           imageUrl,
              //           fit: BoxFit.cover,
              //         ),
              //         Text('\$$price'),
              //       ],
              //     ),
              //   ),
              // ),
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
            subtitle:
                Text('Total : \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text(
              '$quantity x',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
