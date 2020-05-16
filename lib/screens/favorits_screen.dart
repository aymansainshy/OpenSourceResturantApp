import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/favorites_item.dart';
import '../provider/meals.dart';
import '../model/meal.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Meal> favoritesMeal = Provider.of<Meals>(context).favoriteMeal;

    return favoritesMeal.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Text(
                    'You Don\'t Have Favorites Meals Yet Star Add Some.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    'assets/images/brokenHeart.png',
                    color: Colors.grey,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        : ListView(
            children: favoritesMeal
                .map(
                  (favMeal) => FavoritesMealItem(
                    favId: favMeal.id,
                  ),
                )
                .toList(),
          );
  }
}
