import 'package:flutter/material.dart';

import '../screens/meal_detail_screen.dart';
import '../model/meal.dart';

class PopulerItem extends StatelessWidget {
  final Meal meal;

  const PopulerItem({
    this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MealDetailScreen.routeName, arguments: {
          'mealId': meal.id,
        });
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: ListTile(
            leading: Container(
              height: 100,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  meal.imagUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              meal.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Price : \$${meal.price}'),
            trailing: Icon(Icons.arrow_forward)),
      ),
    );
  }
}
