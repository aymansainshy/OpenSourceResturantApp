import 'package:flutter/material.dart';

class StarReview extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final double sizedBox;
  final Widget widget;
  final MainAxisAlignment mainAxis;

  StarReview({
    this.widget,
    this.iconSize = 16.0,
    this.fontSize = 16.0,
    this.sizedBox = 3.0,
    this.mainAxis = MainAxisAlignment.spaceBetween,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxis,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.star,
                  color: Theme.of(context).accentColor, size: iconSize),
              Icon(Icons.star,
                  color: Theme.of(context).accentColor, size: iconSize),
              Icon(Icons.star,
                  color: Theme.of(context).accentColor, size: iconSize),
              Icon(Icons.star_half,
                  color: Theme.of(context).accentColor, size: iconSize),
              Icon(Icons.star_border,
                  color: Theme.of(context).accentColor, size: iconSize),
            ],
          ),
        ),
        SizedBox(width: sizedBox),
        Text(
          '4.5',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        widget,
        Text(
          '(35 Reviews)',
          style: TextStyle(
            color: Colors.grey,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
