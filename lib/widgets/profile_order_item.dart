import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/order.dart';

class ProfileOrderItem extends StatefulWidget {
  final Order order;

  const ProfileOrderItem({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _ProfileOrderItemState createState() => _ProfileOrderItemState();
}

class _ProfileOrderItemState extends State<ProfileOrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Totat : \$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expanded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Container(
                // height: min(widget.order.meals.length * 20.0 + 10, 100)
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.order.meals
                      .map((meal) => Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FittedBox(
                                    child: Image.network(
                                      meal.imageUrl,
                                      width: 130.0,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    meal.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${meal.quantity} x ${meal.price}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
