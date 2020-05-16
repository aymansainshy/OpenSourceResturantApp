import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared_widgets/gestureDetoctor.dart';
import '../screens/meal_detail_screen.dart';
import '../provider/meals.dart';

class FavoritesMealItem extends StatelessWidget {
  final String favId;

  FavoritesMealItem({
    Key key,
    @required this.favId,
  });

  @override
  Widget build(BuildContext context) {
    final loadedFavMeal = Provider.of<Meals>(context).findById(favId);

    void _selectMeal(BuildContext context) {
      Navigator.of(context).pushNamed(MealDetailScreen.routeName, arguments: {
        // 'catogoryId': catogoryId,
        'mealId': favId,
      });
    }

    return BuidGetureDetuctor(
      loadedMeal: loadedFavMeal,
      function: _selectMeal,
    );
  }
}
