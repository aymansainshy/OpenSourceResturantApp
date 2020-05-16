import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_order_item.dart';
import '../provider/orders.dart';
import '../provider/auth.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    final authData = Provider.of<Auth>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 200,
          padding: EdgeInsets.only(top: 15),
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).accentColor,
          child: Column(
            children: <Widget>[
              CircleAvatar(
                // radius: 70,
                maxRadius: 70,
                minRadius: 30,
                backgroundColor: Colors.grey,
              ),
              SizedBox(height: 10),
              Expanded(
                child: Text(
                  authData == null ? 'userName' : authData.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'My Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(

              ///When using [FutureBuilder] set listen [false] ...
              future: Provider.of<Orders>(context, listen: false)
                  .fetchAndSetOrders(),
              builder: (ctx, snapShot) {
                switch (snapShot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.active:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.none:
                    return AlertDialog(
                      title: Text('An error occurred'),
                      content: Text('No Data found!'),
                    );
                    break;
                  case ConnectionState.done:
                    if (snapShot.error != null) {
                      return AlertDialog(
                        title: Text('An error occurred'),
                        content: Text(snapShot.error.toString()),
                      );
                    } else {
                      return Consumer<Orders>(builder: (ctx, orderData, _) {
                        if (orderData.orders.isEmpty) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: Text(
                                'You Don\'t have Orders .',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) => ProfileOrderItem(
                            order: orderData.orders[i],
                          ),
                        );
                      });
                    }
                    break;
                  default:
                }
                return null;
              }),
        ),
      ],
    );
  }
}
