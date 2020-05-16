import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/catogrie.dart';
import '../provider/catogories_list.dart';

class EditCatScreen extends StatefulWidget {
  static const routeName = 'edit_cat_screen';
  @override
  _EditCatScreenState createState() => _EditCatScreenState();
}

class _EditCatScreenState extends State<EditCatScreen> {
  // final _idFocusNode = FocusNode();
  final _symbolFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFcusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editingCat = Catogorie(
    id: null,
    title: '',
    symbol: '',
    imageUrl: '',
  );

  //for editing
  var _initValue = {
    'title': '',
    'symbol': '',
    'imageUrl': '',
  };

  var _isInit = true;

  @override
  void initState() {
    _imageUrlFcusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFcusNode.removeListener(_updateImageUrl);
    _symbolFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFcusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFcusNode.hasFocus) {
      
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

  //fot extrackting catogoryId to Edit it
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final catId = ModalRoute.of(context).settings.arguments as String;
      if (catId != null) {
        _editingCat = Provider.of<CatogoriesList>(context, listen: false)
            .catogoriesList
            .firstWhere((catoId) => catoId.id == catId);
        _initValue = {
          'title': _editingCat.title,
          'symbol': _editingCat.symbol,
          // 'imageUrl': _editingCat.imageUrl,
        };
        _imageUrlController.text = _editingCat.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editingCat.id != null) {
      Provider.of<CatogoriesList>(context, listen: false)
          .updatrCatogorie(_editingCat.id, _editingCat);
    } else {
      Provider.of<CatogoriesList>(context, listen: false)
          .addNewCatogorie(_editingCat);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Color.fromARGB(0, 0, 0, 1),
        elevation: 0.0,
        title: _editingCat.id != null
            ? Text('Edit Catogory')
            : Text('Add Catogorey'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _saveForm,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _initValue['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_symbolFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter provid value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editingCat.title =value;
                },
              ),
              TextFormField(
                initialValue: _initValue['symbol'],
                decoration: InputDecoration(labelText: 'Symbol'),
                textInputAction: TextInputAction.next,
                focusNode: _symbolFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter provid value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editingCat.symbol = value;
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
                      // initialValue: _initValue['imageUrl'],
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFcusNode,
                      controller: _imageUrlController,
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
                      onSaved: (value) {
                        _editingCat.imageUrl = value;
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
