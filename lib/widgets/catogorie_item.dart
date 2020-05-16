import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/meals_screen.dart';
import '../model/catogrie.dart';

class CatogoriesItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final Widget image;

  // CatogoriesItem({
  //   this.id,
  //   this.title,
  //   this.image,
  // });

  @override
  Widget build(BuildContext context) {
    final currentCat = Provider.of<Catogorie>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          MealsScreen.routeName,
          arguments: {
            'id': currentCat.id,
            'symbol': currentCat.symbol,
            'title': currentCat.title,
          },
        );
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Material(
              borderRadius: BorderRadius.circular(40.0),
              elevation: 5.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40.0,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Image.asset(
                    currentCat.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              currentCat.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
