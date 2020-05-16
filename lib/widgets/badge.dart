import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/carts.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.child,
    // @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  // final String value;
  final Color color;

  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context, listen: false);

    return cart.items.isEmpty
        ? child
        : Stack(
            alignment: Alignment.center,
            children: [
              child,
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  // color: Theme.of(context).accentColor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:
                        color != null ? color : Theme.of(context).primaryColor,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Consumer<Carts>(
                    builder: (_, cart, __) => Text(
                      cart.itemCount.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
