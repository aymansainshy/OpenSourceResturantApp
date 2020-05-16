import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/random_list_item.dart';
import '../provider/meals.dart';
import '../model/meal.dart';

class RandomList extends StatefulWidget {
  @override
  _RandomListState createState() => _RandomListState();
}

class _RandomListState extends State<RandomList> {
  var isInit = true;
  var _meals;
  List<Meal> _randomMeals = [];

  @override
  void didChangeDependencies() {

    if (isInit) {
      _meals = Provider.of<Meals>(context, listen: false).meals;
      if (_meals != null) {
        Random random = Random();
        for (int i = 0; i <= 4; i++) {
          var myRandom = random.nextInt(_meals.length);
          _randomMeals.add(_meals[myRandom]);
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

    // List<Meal> _randomMeals = [];

    // for (int i = 0; i <= 4; i++) {
    //   if(_meals != null){
    //   var myRandom = random.nextInt(_meals.length);
    //   _randomMeals.add(_meals[myRandom]);
    //   }
    // }

    return CarouselSlider.builder(
      height: 250,
      aspectRatio: 16 / 9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 3),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      pauseAutoPlayOnTouch: Duration(seconds: 2),
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
      itemCount: _randomMeals.length,
      itemBuilder: (ctx, i) => _meals == null
          ? Container(
              color: Colors.red,
              height: 100,
              width: 100,
            )
          : RandomListItem(
              meal: _randomMeals[i],
            ),
    );
  }
}
