import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/meal_detail_screen.dart';
import '../shared_widgets/star_review.dart';
import '../provider/meals.dart';
import '../provider/auth.dart';
import '../model/meal.dart';

class RandomListItem extends StatefulWidget {
  //other way of fetching Data By mealId
  // final String mealId;

  final Meal meal;

  RandomListItem({
    @required this.meal,
  });

  @override
  _RandomListItemState createState() => _RandomListItemState();
}

class _RandomListItemState extends State<RandomListItem> {
  @override
  Widget build(BuildContext context) {
    final randomMeal =
        Provider.of<Meals>(context, listen: false).findById(widget.meal.id);

        final authData = Provider.of<Auth>(context , listen: false);

    // final currentCatogory = Provider.of<CatogoriesList>(context)
    //     .catogoriesList
    //     .firstWhere((catog) => catog.id == catogoryId);
    _selectRandomMeal(BuildContext context) {
      Navigator.of(context).pushNamed(MealDetailScreen.routeName, arguments: {
        'mealId': randomMeal.id,
        // 'catogoryId': null,
      });
    }

    return GestureDetector(
      onTap: () => _selectRandomMeal(context),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        overflow: Overflow.visible,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            // padding: EdgeInsets.only(left:10,right: 10),
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 8),
                  blurRadius: 8,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                randomMeal.imagUrl,
                // height: 200,
                // width: 350,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: -5,
            child: IconButton(
              padding: EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 20.0,
              ),
              icon: Icon(
                Icons.favorite,
                size: 35,
                color: randomMeal.isFavorite ? Colors.redAccent : Colors.white,
              ),
              onPressed: () async {
                try {
                   randomMeal.toggleFavoriteStatus(authData.token , authData.userId);
                  setState(() {
                    // randomMeal.isFavorite;
                  });
                } catch (e) {
                  setState(() {
                    // randomMeal.isFavorite;
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.black54,
                    content: Text('Process Faild!'),
                    duration: Duration(seconds: 1),
                  ));
                }
                // print(randomMeal.isFavorite);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          randomMeal.title,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: StarReview(
                          mainAxis: MainAxisAlignment.spaceBetween,
                          iconSize: 15.0,
                          fontSize: 14.0,
                          sizedBox: 2.0,
                          widget: Spacer(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 5.0,
                          left: 5.0,
                          right: 5.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _buildRow(
                              icon: Icons.thumb_up,
                              text: '150 Like',
                              fontSize: 14.0,
                              iconSize: 14,
                            ),
                            Spacer(),
                            FittedBox(
                              child: Text(
                                '\$${randomMeal.price}/Person',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildRow({
  IconData icon,
  String text,
  double fontSize = 16.0,
  double iconSize = 16.0,
}) {
  return Row(
    children: <Widget>[
      Icon(
        icon,
        size: iconSize,
        color: Colors.grey,
      ),
      SizedBox(width: 5),
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.grey,
        ),
      ),
    ],
  );
}
