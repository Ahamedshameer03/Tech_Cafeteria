import 'dart:io';

import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/category_service.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  ProductServices _productService = ProductServices();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoryService _categoryService = CategoryService();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  String _currentCategory;
  File _image;

  bool loading = false;
  bool state = false;
  bool noImage = false;

  @override
  void initState() {
    _getCategories();

    //_currentCategory = categoriesDropDown[0].value;
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['category']),
              value: categories[i].data['category'],
            ));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Add Product",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/app_bac.jpg'),
          fit: BoxFit.fill,
        )),
        child: Form(
          key: _formKey,
          child: loading
              ? Loading()
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(
                                SizeConfig.safeBlockHorizontal * 3),
                            child: OutlineButton(
                              borderSide: BorderSide(
                                color: noImage
                                    ? Colors.red.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.5),
                                width: 2.5,
                              ),
                              onPressed: () {
                                _selectImage(ImagePicker.pickImage(
                                    source: ImageSource.gallery));
                              },
                              child: _displayChild(),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(
                                SizeConfig.safeBlockHorizontal * 3),
                            child: Text(
                              'Category',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: SizeConfig.blockSizeVertical * 2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeVertical * 3,
                          ),
                          DropdownButton(
                            icon: Icon(
                              Icons.sort,
                              color: Colors.blue,
                            ),
                            elevation: 2,
                            items: categoriesDropDown,
                            onChanged: changeSelectedCategory,
                            value: _currentCategory,
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: productNameController,
                            decoration: InputDecoration(
                                hintText: 'Enter Product Name',
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: SizeConfig.blockSizeVertical * 2,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'You must enter the product name';
                              } else if (value.length > 15) {
                                return 'Product name cannot have more that 15 characters';
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: quantityController,
                            decoration: InputDecoration(
                                hintText: 'Enter Quantity',
                                labelText: 'Quantity',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: SizeConfig.blockSizeVertical * 2,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'You must enter the quantity';
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            decoration: InputDecoration(
                                hintText: 'Enter Price',
                                labelText: 'Price ( in Rs.)',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: SizeConfig.blockSizeVertical * 2,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'You must enter the price';
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.multiline,
                            //maxLength: 200,
                            maxLines: 6,
                            decoration: InputDecoration(
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 40.0, horizontal: 10.0),
                                hintText: 'About Product...',
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: SizeConfig.blockSizeVertical * 2,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'You must enter the price';
                              }
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: SizeConfig.safeBlockVertical * 3.5,
                            width: SizeConfig.safeBlockVertical * 20,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              'Popular Product',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.blockSizeVertical * 2),
                            ),
                          ),
                          Switch(
                              activeColor: Colors.green,
                              activeTrackColor: Colors.greenAccent[100],
                              //inactiveThumbColor: Colors.red,
                              inactiveTrackColor: Colors.redAccent[100],
                              value: state,
                              onChanged: (bool value) {
                                setState(() {
                                  state = value;
                                });
                              }),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 5,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          validateAndUpload();
                        },
                        child: Text(
                          'Add Product',
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2),
                        ),
                        textColor: Colors.white,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      if (_image != null) {
        String imageUrl;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture = "${productNameController.text}.jpg";
        StorageUploadTask task =
            storage.ref().child("Products/$picture").putFile(_image);

        StorageTaskSnapshot snapshot =
            await task.onComplete.then((snapshot) => snapshot);

        task.onComplete.then((snapshot) async {
          imageUrl = await snapshot.ref.getDownloadURL();

          _productService.uploadProduct(
            productName: productNameController.text,
            price: double.parse(priceController.text),
            imageUrl: imageUrl,
            quantity: int.parse(quantityController.text),
            category: _currentCategory,
            featured: state,
            description: descriptionController.text,
          );
          _formKey.currentState.reset();
          setState(() {
            loading = false;
          });
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(
                      'Product "${productNameController.text}" Added Successfully'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        });
      } else {
        setState(() {
          noImage = true;
          loading = false;
        });
      }
    }
  }

  Widget _displayChild() {
    if (_image == null) {
      if (noImage) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              SizeConfig.blockSizeHorizontal * 8,
              SizeConfig.blockSizeHorizontal * 15,
              SizeConfig.blockSizeHorizontal * 8,
              SizeConfig.blockSizeHorizontal * 15),
          child: new Icon(
            Icons.add_photo_alternate,
            color: Colors.red,
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              SizeConfig.blockSizeHorizontal * 8,
              SizeConfig.blockSizeHorizontal * 15,
              SizeConfig.blockSizeHorizontal * 8,
              SizeConfig.blockSizeHorizontal * 15),
          child: new Icon(
            Icons.add_photo_alternate,
            color: Colors.grey,
          ),
        );
      }
    } else {
      return Image.file(
        _image,
        scale: 10,
      );
    }
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data['category'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  void _selectImage(Future<File> pickImage) async {
    _image = await pickImage;
    _displayChild();
  }
}
