import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../provider/catogories_list.dart';
import '../widgets/catogory_choice.dart';
import '../model/catogrie.dart';
import '../provider/meals.dart';
import '../model/meal.dart';

class EditMealScreen extends StatefulWidget {
  static const routeName = 'Edit_Meal_screen';

  @override
  _EditMealScreenState createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _imageUrlController = TextEditingController();
  final _pricFocusNode = FocusNode();
  // final _catogoreyFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode =
      FocusNode(); // to render image when we lose focus 0

  final _formKey = GlobalKey<FormState>();
  //to add New Meal  / should Write _addingMeal Not _editedMeal .. i well change it later :)
  var _editedMeal = Meal(
    id: null,
    imagUrl: '',
    catogories: null,
    title: '',
    price: 0.0,
    description: '',
    isFavorite: false,
  );

  @override
  void initState() {
    _imageUrlFocusNode
        .addListener(_updateImageUrl); // to render image when we lose focus 1
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(
        _updateImageUrl); // to render image when we lose focus 3
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    // _catogoreyFocusNode.dispose();
    _pricFocusNode.dispose();
    super.dispose();
  }

  // to render image when we lose focus 2
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  var isLoading = false;

  /// [_saveMealForm] to save [editing] or [adding] new [meal]
  Future<void> _saveMealForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_editedMeal.id != null) {
      //to add [list of category] to [meal]
      _editedMeal.catogories =
          Provider.of<CatogoriesList>(context, listen: false).mySelectedCat;

      // [Update] existing [Meal]
      try {
      await  Provider.of<Meals>(context, listen: false)
            .updatingMeal(_editedMeal.id, _editedMeal);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('Something went wrong !'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }

/////////////////////////////////////////////////////////////////////////////////


    } else {
      //to add [list of category] to [meal]
      _editedMeal.catogories =
          Provider.of<CatogoriesList>(context, listen: false).mySelectedCat;

      //Add [New Meal]
      try {
        await Provider.of<Meals>(context, listen: false)
            .addNewMeal(_editedMeal);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('Something went wrong !'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    // Navigator.of(context).pop();
  }

  ///////[Updating] Meal [Start] ////////////////////////////////////////////////////
  var _initMealValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
    // 'catogories': '',
  };

  var _isInit = true;
  var mealId;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      mealId = ModalRoute.of(context).settings.arguments as String;
      if (mealId != null) {
        _editedMeal =
            Provider.of<Meals>(context, listen: false).findById(mealId);

        //when we are in [editing] mode  [mySymbol List = my editing Meal]
        Provider.of<CatogoriesList>(context)
            .addSymbolList(_editedMeal.catogories);

        _initMealValue = {
          'title': _editedMeal.title,
          'price': _editedMeal.price.toString(),
          'description': _editedMeal.description,
          // 'imageUrl': _editedMeal.imagUrl,
          // 'catogories': _editedMeal.catogories.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedMeal.imagUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }
/////////[updating] Meal [End]/////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    List<Catogorie> myCurrentCat =
        Provider.of<CatogoriesList>(context).catogoriesList;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Color.fromARGB(0, 0, 0, 1),
        elevation: 0.0,
        title: _editedMeal.id != null ? Text('Edit Meal') : Text('Add Meal'),
        // actions: <Widget>[
        //   IconButton(
        //     padding: EdgeInsets.symmetric(
        //       horizontal: 20.0,
        //       vertical: 20.0,
        //     ),
        //     icon: Icon(Icons.arrow_back, size: 30),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //       // Provider.of<CatogoriesList>(context).emptyMySelectedCat();
        //     },
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _saveMealForm,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initMealValue['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricFocusNode);
                        },
                        onSaved: (value) {
                          _editedMeal.title = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter provid title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initMealValue['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedMeal.price = double.parse(value);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter provid price ';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'The price should be greater than ZERO';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Category List : ${Provider.of<CatogoriesList>(context, listen: false).mySelectedCat}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 130,
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Theme.of(context).accentColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                            // scrollDirection: Axis.horizontal,
                            itemCount: myCurrentCat.length,
                            itemBuilder: (ctx, i) {
                              return CategoryChoice(
                                cat: myCurrentCat[i],
                                mealCatogories: _editedMeal.id != null
                                    ? _editedMeal.catogories
                                    : null,
                              );
                            }),
                      ),
                      // TextFormField(
                      //   initialValue: _initMealValue['catogories'],
                      //   decoration: InputDecoration(labelText: 'Catogories'),
                      //   textInputAction: TextInputAction.next,
                      //   focusNode: _catogoreyFocusNode,
                      //   onFieldSubmitted: (_) {
                      //     FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      //   },
                      //   onSaved: (value) {
                      //     _editedMeal = Meal(
                      //       id: _editedMeal.id,
                      //       isFavorite: _editedMeal.isFavorite,
                      //       catogories: [value],
                      //       title: _editedMeal.title,
                      //       description: _editedMeal.description,
                      //       imagUrl: _editedMeal.imagUrl,
                      //       price: _editedMeal.price,
                      //     );
                      //   },
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       return 'Please enter provid value';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      TextFormField(
                        initialValue: _initMealValue['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedMeal.description = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter provid value';
                          }
                          if (value.length < 10) {
                            return 'The description should be at least 10 character';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(right: 8, top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text('Enter Url'))
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _initMealValue['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                _editedMeal.imagUrl = value;
                              },
                              onFieldSubmitted: (_) {
                                _saveMealForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Enter a valid image Url';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
