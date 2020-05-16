import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/meal.dart';

class Meals with ChangeNotifier {
  List<Meal> _meals = [
    Meal(
      id: 'b1',
      catogories: [
        'burger',
      ],
      title: 'British Burger',
      description:
          """In a large bowl, sift together the flour, baking powder, salt and sugar
Make a well in the center and pour in the milk, egg and melted butter; mix until smooth
Heat a lightly oiled griddle or frying pan over medium high heat.
Pour or scoop the batter onto the griddle, using approximately 1/4 cup for each pancake. Brown on both sides and """,
      imagUrl:
          'https://www.honestburgers.co.uk/wp-content/uploads/2020/02/beef-burger-with-bacon-fondue-and-onion-billboard.jpg',
      price: 23.99,
    ),
    Meal(
      id: 'b2',
      catogories: [
        'burger',
      ],
      title: 'Burger King',
      description:
          """In a large bowl, sift together the flour, baking powder, salt and sugar
Make a well in the center and pour in the milk, egg and melted butter; mix until smooth
Heat a lightly oiled griddle or frying pan over medium high heat.""",
      imagUrl:
          'https://img.etimg.com/thumb/width-640,height-480,imgsize-951452,resizemode-1,msid-66325015/burger-king-leaves-starbucks-behind.jpg',
      price: 30.99,
    ),
  ];

    static const String firebaseAppUrl = 'Copy Past Your own firebase app url';

  final String authToken;
  final String userId;

  Meals(this.authToken, this.userId, this._meals);

  List<Meal> get meals {
    return [..._meals];
  }

  List<Meal> get favoriteMeal {
    return _meals.where((mealItem) => mealItem.isFavorite).toList();
  }

  Meal findById(String id) {
    return _meals.firstWhere((cmeal) => cmeal.id == id);
  }

  Future<void> fetchAndSetMeals() async {
    var url =
        '$firebaseAppUrl/meals.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      if (loadedData == null) {
        return;
      }

      ///to fetch the [favorits] Status of the [userId] for the current [Meals]......
      url =
          '$firebaseAppUrl/userFavorits/$userId.json?auth=$authToken';
      final favoritsRespons = await http.get(url);
      final favoritsData = json.decode(favoritsRespons.body);
      // print(json.decode(favoritsRespons.body));

      final List<Meal> loadedMeals = [];

      loadedData.forEach((mealId, mealData) {
        loadedMeals.add(
          Meal(
            // This way Object of Object or you can save it in Object instead of  list => Meal meal;
            id: mealId,
            title: mealData['title'],
            imagUrl: mealData['imagUrl'],
            catogories: mealData['catogories'],
            description: mealData['description'],
            price: mealData['price'],
            // isFavorite: mealData['isFavorite'],
            isFavorite:
                favoritsData == null ? false : favoritsData[mealId] ?? false,
          ),
        );
      });
      _meals = loadedMeals;
      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> addNewMeal(Meal meal) async {
    final url =
        '$firebaseAppUrl/meals.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': meal.title,
          'catogories': meal.catogories,
          'description': meal.description,
          'imagUrl': meal.imagUrl,
          'price': meal.price,
          // 'isFavorite': meal.isFavorite
        }),
      );

      final newMeal = Meal(
        id: json.decode(response.body)['name'],
        catogories: meal.catogories,
        title: meal.title,
        description: meal.description,
        imagUrl: meal.imagUrl,
        price: meal.price,
      );
      _meals.insert(0, newMeal);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /// HTTP for [patch] [put] [delete] doesn't throw an [Error] Statuse Code.

  Future<void> updatingMeal(String id, Meal newMeal) async {
    final mealIndex = _meals.indexWhere((meal) => meal.id == id);
    if (mealIndex >= 0) {
      final url =
          '$firebaseAppUrl/meals/$id.json?auth=$authToken';
      final response = await http.patch(url,
          body: json.encode({
            'title': newMeal.title,
            'catogories': newMeal.catogories,
            'price': newMeal.price,
            'imagUrl': newMeal.imagUrl,
            'description': newMeal.description,
          }));

      if (response.statusCode != 200) {
        throw Exception();
      }
      _meals[mealIndex] = newMeal;
      notifyListeners();
    } else {
      print('..........');
    }
  }

  Future<void> removeMeal(String mealId) async {
    final exestingMealIndex = _meals.indexWhere((meal) => meal.id == mealId);
    Meal exestingMeal = _meals[exestingMealIndex];

    _meals.removeAt(exestingMealIndex);
    notifyListeners();

    final url =
        '$firebaseAppUrl/meals/$mealId.json?auth=$authToken';
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      exestingMeal = null;
      notifyListeners();
    }
    _meals.insert(exestingMealIndex, exestingMeal);
    notifyListeners();
    throw Exception();

    // _meals.removeWhere((meal) => meal.id == mealId);
  }
}
