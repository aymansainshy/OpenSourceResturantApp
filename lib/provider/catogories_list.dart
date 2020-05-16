import 'package:flutter/cupertino.dart';

import 'package:resturant/model/catogrie.dart';

class CatogoriesList with ChangeNotifier {
  List<dynamic> _mySelectedCat = [];

  final List<Catogorie> _catogeriesList = [
    Catogorie(
      id: 'c1',
      title: 'BreakFast',
      symbol: 'break',
      imageUrl: 'assets/images/lunch.png',
    ),
    Catogorie(
      id: 'c2',
      title: 'Lunch',
      symbol: 'lunch',
      imageUrl: 'assets/images/preak.png',
    ),
    Catogorie(
      id: 'c3',
      title: 'Burger',
      symbol: 'burger',
      imageUrl: 'assets/images/burger.png',
    ),
    Catogorie(
      id: 'c4',
      title: 'Chips',
      symbol: 'chips',
      imageUrl: 'assets/images/chips.png',
    ),
    Catogorie(
      id: 'c5',
      title: 'Pizza',
      symbol: 'pizza',
      imageUrl: 'assets/images/pizza.png',
    ),
    Catogorie(
      id: 'c6',
      title: 'Drink',
      symbol: 'drink',
      imageUrl: 'assets/images/drink.png',
    ),
  ];

  List<Catogorie> get catogoriesList {
    return List.from(_catogeriesList);
  }

  void addNewCatogorie(Catogorie catogorie) {
    final newCatogorie = Catogorie(
      id: DateTime.now().toIso8601String(),
      title: catogorie.title,
      symbol: catogorie.symbol,
      imageUrl: catogorie.imageUrl,
    );
    _catogeriesList.insert(0, newCatogorie);
    notifyListeners();
  }

  void updatrCatogorie(String id, Catogorie editingCatogorie) {
    final catIndex = _catogeriesList.indexWhere((cat) => cat.id == id);
    if (catIndex >= 0) {
      _catogeriesList[catIndex] = editingCatogorie;
      notifyListeners();
    } else {
      print('....');
    }
  }

  void removeCat(String catId) {
    _catogeriesList.removeWhere((cato) => cato.id == catId);
    notifyListeners();
  }

  //////////////////////////////////////////////////////////
  List<dynamic> get mySelectedCat {
    return List.from(_mySelectedCat);
  }

  void addSymobl(dynamic symbol) {
    _mySelectedCat.add(symbol);
    notifyListeners();
  }

  void addSymbolList(List<dynamic> symbolList) {
    _mySelectedCat = symbolList;
    notifyListeners();
  }

  void removeSymbol(dynamic symbol) {
    _mySelectedCat.remove(symbol);
    notifyListeners();
  }

  void emptyMySelectedCat() {
    _mySelectedCat.clear();
    notifyListeners();
  }
}
