import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/meal.dart';
import '../provider/meals.dart';
import '../widgets/populer_item.dart';

class Populer extends StatefulWidget {
  final bool isSeeAll;

  Populer({
    this.isSeeAll,
  });

  @override
  _PopulerState createState() => _PopulerState();
}

class _PopulerState extends State<Populer> {
  var isInit = true;
  var _meals;
  List<Meal> _populer = [];

  @override
  void didChangeDependencies() {
    if (isInit) {
      _meals = Provider.of<Meals>(context, listen: false).meals;
      if (_meals != null) {
        Random random = Random();
        for (int i = 0; i <= 3; i++) {
          var myRandom = random.nextInt(_meals.length);
          _populer.add(_meals[myRandom]);
        }
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final _meals = Provider.of<Meals>(context, listen: false).meals;
    // Random random = Random();

    // List<Meal> _populer = [];

    // for (int i = 0; i <= 4; i++) {
    //   if (_meals != null) {
    //     var myRandom = random.nextInt(_meals.length);
    //     _populer.add(_meals[myRandom]);
    //   }
    // }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: _meals == null
          ? Container(
              color: Colors.red,
              height: 100,
              width: 100,
            )
          : widget.isSeeAll
              ? Card(
                  child: Column(
                    children: _populer
                        .map((popMeal) => PopulerItem(meal: popMeal))
                        .toList(),
                  ),
                )
              : Card(
                  child: PopulerItem(
                    meal: _populer[0],
                  ),
                ),
    );
  }
}
