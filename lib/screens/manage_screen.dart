import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/catogories_list.dart';
import '../screens/edit_meal_screen.dart';
import '../screens/edit_cat_screen.dart';
import '../shared_widgets/darwer.dart';
import '../provider/meals.dart';

class ManageScreen extends StatefulWidget {
  static const routeName = 'Manager_screen';

  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  bool isCatogory = true;

  @override
  Widget build(BuildContext context) {
    final myCatogorie = Provider.of<CatogoriesList>(context);
    final myMeal = Provider.of<Meals>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          textTheme: Theme.of(context).textTheme,
          actionsIconTheme: Theme.of(context).accentIconTheme,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Color.fromARGB(0, 0, 0, 1),
          elevation: 0.0,
          title: Text('Manage Meals'),
          bottom: TabBar(
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Theme.of(context).primaryColor,
            onTap: (int value) {
              switch (value) {
                case 0:
                  isCatogory = true;
                  break;
                case 1:
                  isCatogory = false;
                  break;
                default:
                  isCatogory = true;
              }
            },
            tabs: <Widget>[
              Tab(
                text: 'Catogorey',
                icon: Icon(
                  Icons.category,
                ),
              ),
              Tab(
                text: 'Meal',
                icon: Icon(
                  Icons.restaurant,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              if (isCatogory) {
                Navigator.of(context).pushNamed(EditCatScreen.routeName);
              } else {
                Navigator.of(context).pushNamed(EditMealScreen.routeName);

                //to clear the list of symbol
                Provider.of<CatogoriesList>(context, listen: false)
                    .emptyMySelectedCat();
              }
            }),
        drawer: SharedDrawer(),
        body: TabBarView(
          children: <Widget>[
            ManagCatItem(myCatogorie: myCatogorie),
            ManagMealItem(myMeal: myMeal),
          ],
        ),
      ),
    );
  }
}

class ManagCatItem extends StatelessWidget {
  const ManagCatItem({
    Key key,
    @required this.myCatogorie,
  }) : super(key: key);

  final CatogoriesList myCatogorie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: myCatogorie.catogoriesList.length,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            title: Text(
              myCatogorie.catogoriesList[i].title,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.white,
              child: Image.asset(myCatogorie.catogoriesList[i].imageUrl),
            ),
            subtitle: Text(myCatogorie.catogoriesList[i].symbol),
            trailing: Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditCatScreen.routeName,
                          arguments: myCatogorie.catogoriesList[i].id);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () {
                      myCatogorie.removeCat(myCatogorie.catogoriesList[i].id);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ManagMealItem extends StatelessWidget {
  const ManagMealItem({
    Key key,
    @required this.myMeal,
  }) : super(key: key);

  final Meals myMeal;

  Future<void> _refreshMeals(BuildContext context) async {
    await Provider.of<Meals>(context, listen: false).fetchAndSetMeals();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshMeals(context),
      child: ListView.builder(
        itemCount: myMeal.meals.length,
        itemBuilder: (ctx, i) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: Image.network(
                        myMeal.meals[i].imagUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    myMeal.meals[i].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '\$${myMeal.meals[i].price}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Catogories :',
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Container(
                                            height: 30,
                                            width: 130,
                                            child: ListView(
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: myMeal
                                                    .meals[i].catogories
                                                    .map(
                                                      (mealCat) => Card(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Text(mealCat),
                                                        ),
                                                      ),
                                                    )
                                                    .toList()),
                                          ),
                                          Spacer(),
                                          Expanded(
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                  EditMealScreen.routeName,
                                                  arguments: myMeal.meals[i].id,
                                                );

                                                // to clear Category symbol List
                                                // Provider.of<CatogoriesList>(
                                                //         context,
                                                //         listen: false)
                                                //     .emptyMySelectedCat();
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Theme.of(context)
                                                    .errorColor,
                                              ),
                                              onPressed: () async {
                                                try {
                                                  await myMeal.removeMeal(
                                                      myMeal.meals[i].id);
                                                } catch (error) {
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      content: Text(
                                                        'Delete faild !',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
