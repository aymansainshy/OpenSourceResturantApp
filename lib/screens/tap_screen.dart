import 'package:flutter/material.dart';

import '../screens/favorits_screen.dart';
import '../screens/profile_screen.dart';
import '../shared_widgets/darwer.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';
import '../widgets/badge.dart';

class TapScreen extends StatefulWidget {
  static const routeName = 'Tap_screen';

  @override
  _TapScreenState createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreen(),
      'title': 'Home',
    },
    {
      'page': FavoritesScreen(),
      'title': 'Favorites',
    },
    {
      'page': CartScreen(),
      'title': 'Cart ',
    },
    {
      'page': ProfileScreen(),
      'title': 'Profile',
    },
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SharedDrawer(),
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Color.fromARGB(0, 0, 0, 1),
        elevation: 0.0,
        title: Text(
          _pages[_selectedPageIndex]['title'],
          //   style: TextStyle(
          //     color: Theme.of(context).primaryColor,
          //   ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            //icon could be any widget .....
            icon: Icon(
              Icons.home,
            ),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: Badge(
              child: Icon(Icons.shopping_cart),
              // value: 3.toString(),
            ),
            title: Text('Cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
