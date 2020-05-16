import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/catogories_list.dart';
import '../shared_widgets/star_review.dart';
import '../provider/orders.dart';
import '../provider/meals.dart';
import '../provider/carts.dart';
import '../provider/auth.dart';
import '../model/meal.dart';

class MealDetailScreen extends StatefulWidget {
  // final Meal meal;
  // final String catId;

  static const routeName = 'Meal-Detail-Screen';

  // const MealDetailScreen({Key key, this.meal, this.catId}) : super(key: key);

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  ///to show [snackbar] from this [Scaffold]
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //_scaffoldKey.currentState.showSnackBar .....

  /// or use [Builder] widget ... scafold.of(context).....

  Meal currentMeal;
  var currentCatogory;
  var catogoryId;
  var _isInit = true;

  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routArg =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final mealId = routArg['mealId'];

      catogoryId = routArg['catogoryId'];
      currentMeal = Provider.of<Meals>(context, listen: false).findById(mealId);
      // print(catogoryId);

      if (catogoryId != null) {
        currentCatogory = Provider.of<CatogoriesList>(context)
            .catogoriesList
            .firstWhere((catog) => catog.id == catogoryId);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final routArg =
    //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    // final mealId = routArg['mealId'];
    // final catogoryId = routArg['catogoryId'];
    // print(catogoryId);

    final cart = Provider.of<Carts>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    // print(currentCatogory);

    // final currentMeal =
    //     Provider.of<Meals>(context, listen: false).findById(mealId);
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, right: 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FloatingActionButton(
                heroTag: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : Text(
                        'Order Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (cart.items.isNotEmpty) {
                    return;
                  }
                  cart.addItem(
                    currentMeal.id,
                    currentMeal.price,
                    currentMeal.title,
                    currentMeal.imagUrl,
                  );
                  try {
                    await Provider.of<Orders>(context, listen: false).addOrder(
                      cart.items.values.toList(),
                      cart.totalAmount,
                    );
                    cart.clear();
                    setState(() {
                      isLoading = false;
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: Colors.black54,
                      content: Text('You order is Done!'),
                      duration: Duration(seconds: 1),
                    ));
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: Colors.black54,
                      content: Text('You cann\'t order now Try later!'),
                      duration: Duration(seconds: 1),
                    ));
                  }
                },
              ),
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.add_shopping_cart,
                size: 25,
                color: Colors.white,
              ),
              onPressed: () {
                cart.addItem(
                  currentMeal.id,
                  currentMeal.price,
                  currentMeal.title,
                  currentMeal.imagUrl,
                );
                _scaffoldKey.currentState.hideCurrentSnackBar();
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.black54,
                    content: Text('Added meal to cart!'),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(currentMeal.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            textTheme: Theme.of(context).textTheme,
            // actionsIconTheme: Theme.of(context).accentIconTheme,
            // iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Color.fromARGB(0, 0, 0, 1),
            elevation: 0.0,
            automaticallyImplyLeading: false,
            expandedHeight: 300,
            pinned: true,
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                icon: Icon(Icons.arrow_back, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Spacer(),
              IconButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 20.0,
                ),
                icon: Icon(
                  Icons.favorite,
                  size: 35,
                  color:
                      currentMeal.isFavorite ? Colors.redAccent : Colors.white,
                ),
                onPressed: () async {
                  try {
                     currentMeal.toggleFavoriteStatus(
                        authData.token, authData.userId);
                    setState(() {
                      // currentMeal.isFavorite;
                    });
                  } catch (e) {
                    setState(() {
                      // currentMeal.isFavorite;
                    });
                    SnackBar(
                      backgroundColor: Colors.black54,
                      content: Text('Process Faild!'),
                      duration: Duration(seconds: 1),
                    );
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: currentMeal.id,
                child: Image.network(
                  currentMeal.imagUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        currentMeal.title,
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      StarReview(
                        iconSize: 20,
                        fontSize: 16,
                        widget: Spacer(),
                        mainAxis: MainAxisAlignment.spaceAround,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 15.0,
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (catogoryId != null)
                        _buildRow(
                          image: Image.asset(
                            currentCatogory.imageUrl,
                            fit: BoxFit.cover,
                          ),
                          text: currentCatogory.title,
                        ),
                      if (catogoryId == null)
                        _buildRow(
                          image: Image.network(
                            currentMeal.imagUrl,
                            fit: BoxFit.cover,
                          ),
                          text: currentMeal.title,
                        ),
                      _buildRow(
                          icon: Icons.thumb_up, text: '150 Like', size: 2.0),
                      Text(
                        '\$${currentMeal.price}/Person',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Divider(thickness: 2),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Introduction',
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        currentMeal.description,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic),
                      ),
                      // Row(
                      //   children: <Widget>[
                      //     Expanded(
                      //       child: _buildRaisedButton(
                      //         context,
                      //         Text(
                      //           'Order Now',
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             color: Colors.white,
                      //             letterSpacing: 1,
                      //           ),
                      //         ),
                      //         () {
                      //           if (cart.items.isNotEmpty) {
                      //             return;
                      //           }
                      //           cart.addItem(
                      //             currentMeal.id,
                      //             currentMeal.price,
                      //             currentMeal.title,
                      //             currentMeal.imagUrl,
                      //           );
                      //           Provider.of<Orders>(context, listen: false)
                      //               .addOrder(
                      //             cart.items.values.toList(),
                      //             cart.totalAmount,
                      //           );
                      //           cart.clear();
                      //         },
                      //       ),
                      //     ),
                      //     SizedBox(width: 10.0),

                      //builder to show snackBar within widget
                      // Builder(
                      //   builder: (context) => _buildRaisedButton(
                      //     context,
                      //     Icon(
                      //       Icons.add_shopping_cart,
                      //       color: Colors.white,
                      //     ),
                      //     () {
                      //       cart.addItem(
                      //         currentMeal.id,
                      //         currentMeal.price,
                      //         currentMeal.title,
                      //         currentMeal.imagUrl,
                      //       );
                      //       Scaffold.of(context).hideCurrentSnackBar();
                      //       Scaffold.of(context).showSnackBar(
                      //         SnackBar(
                      //           backgroundColor: Colors.black54,
                      //           content: Text('Added meal to cart!'),
                      //           duration: Duration(seconds: 1),
                      //           action: SnackBarAction(
                      //             label: 'UNDO',
                      //             onPressed: () {
                      //               cart.removeSingleItem(currentMeal.id);
                      //             },
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      //   ],
                      // ),
                      SizedBox(height: 60.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // RaisedButton _buildRaisedButton(
  //     BuildContext ctx, Widget widget, Function onPressed) {
  //   return RaisedButton(
  //     color: Theme.of(ctx).accentColor,
  //     child: widget,
  //     onPressed: onPressed,
  //   );
  // }

  Widget _buildRow(
      {Widget image, IconData icon, String text, double size = 5.0}) {
    return Row(
      children: <Widget>[
        Container(
          height: 18.0,
          width: 18.0,
          child: image,
        ),
        if (image == null)
          Icon(
            icon,
            size: 16.0,
            color: Colors.grey,
          ),
        SizedBox(width: size),
        Text(
          text,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
