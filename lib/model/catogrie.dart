import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Catogorie with ChangeNotifier {
  String id;
  dynamic symbol;
  String title;
  String imageUrl;

  Catogorie({
    @required this.id,
    @required this.symbol,
    @required this.title,
    @required this.imageUrl,
  });
}

