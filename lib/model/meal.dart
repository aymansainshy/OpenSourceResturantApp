import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Meal with ChangeNotifier {
  String id;
  List<dynamic> catogories;
  String title;
  String description;
  String imagUrl;
  double price;
  bool isFavorite;

  Meal({
    @required this.id,
    @required this.catogories,
    @required this.title,
    @required this.description,
    @required this.imagUrl,
    @required this.price,
    this.isFavorite = false,
  });
      
    static const String firebaseAppUrl = 'Copy Past Your own firebase app url';

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatuse = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        '$firebaseAppUrl/userFavorits/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatuse;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldStatuse;
      notifyListeners();
      throw e;
    }
  }
}

// To parse this JSON data, do
//
//     final meals = mealsFromJson(jsonString);

// import 'dart:convert';

// Map<String, Meals> mealsFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Meals>(k, Meals.fromMap(v)));

// String mealsToJson(Map<String, Meals> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())));

// class Meals {
//     List<String> catogories;
//     String description;
//     String imagUrl;
//     bool isFavorite;
//     double price;
//     String title;

//     Meals({
//         this.catogories,
//         this.description,
//         this.imagUrl,
//         this.isFavorite,
//         this.price,
//         this.title,
//     });

//     factory Meals.fromMap(Map<String, dynamic> json) => Meals(
//         catogories: json["catogories"] == null ? null : List<String>.from(json["catogories"].map((x) => x)),
//         description: json["description"] == null ? null : json["description"],
//         imagUrl: json["imagUrl"] == null ? null : json["imagUrl"],
//         isFavorite: json["isFavorite"] == null ? null : json["isFavorite"],
//         price: json["price"] == null ? null : json["price"].toDouble(),
//         title: json["title"] == null ? null : json["title"],
//     );

//     Map<String, dynamic> toMap() => {
//         "catogories": catogories == null ? null : List<dynamic>.from(catogories.map((x) => x)),
//         "description": description == null ? null : description,
//         "imagUrl": imagUrl == null ? null : imagUrl,
//         "isFavorite": isFavorite == null ? null : isFavorite,
//         "price": price == null ? null : price,
//         "title": title == null ? null : title,
//     };
// }
