import 'package:flutter/material.dart';


import '../model/meal.dart';
import '../shared_widgets/star_review.dart';

class BuidGetureDetuctor extends StatelessWidget {
  const BuidGetureDetuctor({
    Key key,
    @required this.loadedMeal,
    @required this.function,
  }) : super(key: key);

  final Meal loadedMeal;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(context),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)),
                child: Hero(
                  tag: loadedMeal.id,
                  child: Image.network(
                    loadedMeal.imagUrl,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        loadedMeal.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          wordSpacing: 3.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 25.0,
                          bottom: 5.0,
                        ),
                        child: StarReview(
                          iconSize: 18,
                          fontSize: 16,
                          widget: Spacer(),
                          mainAxis: MainAxisAlignment.spaceAround,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                          Text(
                            '250 Like',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '\$${loadedMeal.price}/Person',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
