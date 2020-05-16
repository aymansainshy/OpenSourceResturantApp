import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/meals.dart';
import '../widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  static const routeName = 'Meals-screen';

  @override
  Widget build(BuildContext context) {
    final routArg =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final catogoryTitle = routArg['title'];
    final catogoryId = routArg['id'];
    final catogroySymbol = routArg['symbol'];

    final loadedMeal = Provider.of<Meals>(context)
        .meals
        .where((meal) => meal.catogories.contains(catogroySymbol))
        .toList();

    return Scaffold(
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Color.fromARGB(0, 0, 0, 1),
        elevation: 0.0,
        title: Text(
          catogoryTitle,
          //   style: TextStyle(
          //     color: Theme.of(context).primaryColor,
          //   ),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: loadedMeal[index],
            child: MealItem(
                // meal: loadedMeal[index],
                catogoryId: catogoryId,
                ),
          ),
          itemCount: loadedMeal.length,
        ),
      ),
    );
  }
}
