import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/meal_detail_screen.dart';
import './screens/edit_meal_screen.dart';
import './provider/catogories_list.dart';
import './screens/edit_cat_screen.dart';
import './screens/manage_screen.dart';
import './screens/orders_screen.dart';
import './screens/meals_screen.dart';
import './screens/auth_screen.dart';
import './screens/tap_screen.dart';
import './provider/orders.dart';
import './provider/meals.dart';
import './provider/carts.dart';
import './provider/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: CatogoriesList(),
        ),

        /// We use [ProxyProvider] when the widget depends on other widget [Auth] & [Meals]
        ChangeNotifierProxyProvider<Auth, Meals>(
          update: (context, auth, previosMeals) => Meals(
            auth.token,
            auth.userId,
            previosMeals == null ? [] : previosMeals.meals,
          ),
          create: (ctx) => null,
        ),

        ChangeNotifierProvider.value(
          value: Carts(),
        ),

        /// We use [ProxyProvider] when the widget depends on other widget [Auth] & [Orders]
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previosOrders) => Orders(
            auth.token,
            auth.userId,
            previosOrders == null ? [] : previosOrders.orders,
          ),
          create: (ctx) => null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Restrant App',
          theme: ThemeData(
            // primaryColor: Colors.white70,
            primarySwatch: Colors.red,
            accentColor: Colors.orange,
          ),
          home: auth.isAuth
              ? StartScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (context, authResultSnapShot) =>
                      authResultSnapShot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          :  AuthScreen(),
                ),
          routes: {
            MealsScreen.routeName: (ctx) => MealsScreen(),
            MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            TapScreen.routeName: (ctx) => TapScreen(),
            ManageScreen.routeName: (ctx) => ManageScreen(),
            EditCatScreen.routeName: (ctx) => EditCatScreen(),
            EditMealScreen.routeName: (ctx) => EditMealScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // var isInit = true;
  // var isLoading = false;
  // @override
  // void didChangeDependencies() {
  //   if (isInit) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     Provider.of<Meals>(context, listen: false).fetchAndSetMeals().then((_) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //   }
  //   isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Meals>(context, listen: false).fetchAndSetMeals(),
        builder: (BuildContext context, AsyncSnapshot dataSnapshot) {
          /// and optionally either [data] or [error] (but not both).
          // if (dataSnapshot.hasData) {
          switch (dataSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.none:
              return AlertDialog(
                title: Text('An error occurred'),
                content: Text('Data not found!'),
              );
            case ConnectionState.done:
              if (dataSnapshot.error != null) {
                return AlertDialog(
                  title: Text('An error occurred'),
                  content: Text('No internet connection !'),
                );
              } else {
                return TapScreen();
              }
              break;
            default:
          }
          // }

          return null;
        },
      ),
    );
  }
}
