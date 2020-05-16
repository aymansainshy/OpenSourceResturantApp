import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/catogories_list.dart';
import '../widgets/catogorie_item.dart';

class Catogories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final catogorie = Provider.of<CatogoriesList>(context).catogoriesList;

    return Container(
      height: 150,
      // color: Colors.red,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: catogorie.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: catogorie[i],
          child: CatogoriesItem(
              // id: catData.id,
              // title: catData.title,
              // image: catData.imageUrl,
              ),
        ),
      ),
    );
  }
}
