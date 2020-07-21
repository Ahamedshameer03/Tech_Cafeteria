import 'dart:io';

import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/services/add_product.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/add_category.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  ProductService _productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  String _currentCategory;
  File _image;

  bool loading = false;

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
        /*leading: Icon(
          Icons.close,
          color: Colors.black,
        ),*/

        title: Text(
          "Add Product",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: loading
            ? Center(child: CircularProgressIndicator())
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
                              color: Colors.grey.withOpacity(0.5),
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
                                color: Colors.red,
                                fontSize: SizeConfig.blockSizeVertical * 2),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeVertical * 3,
                        ),
                        DropdownButton(
                          items: categoriesDropDown,
                          onChanged: changeSelectedCategory,
                          value: _currentCategory,
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                      child: TextFormField(
                        controller: productNameController,
                        decoration: InputDecoration(
                            hintText: 'Enter Product Name',
                            labelText: 'Product Name',
                            labelStyle: TextStyle(
                                color: Colors.red,
                                fontSize: SizeConfig.blockSizeVertical * 2),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
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
                    Padding(
                      padding:
                          EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: quantityController,
                        decoration: InputDecoration(
                            hintText: 'Enter Quantity',
                            labelText: 'Quantity',
                            labelStyle: TextStyle(
                              color: Colors.red,
                              fontSize: SizeConfig.blockSizeVertical * 2,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the quantity';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        decoration: InputDecoration(
                            hintText: 'Enter Price',
                            labelText: 'Price ( in Rs.)',
                            labelStyle: TextStyle(
                                color: Colors.red,
                                fontSize: SizeConfig.blockSizeVertical * 2),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            )),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the price';
                          }
                        },
                      ),
                    ),
                    FlatButton(
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
    );
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      if (_image != null) {
        print(_image);
        String imageUrl;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture = "${productNameController.text}.jpg";
        StorageUploadTask task = storage.ref().child(picture).putFile(_image);

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
          );
          _formKey.currentState.reset();
          setState(() {
            loading = false;
          });
          Navigator.pop(context);
        });
      } else {
        print(_image);
      }
    }
  }

  Widget _displayChild() {
    print(_image);
    if (_image == null) {
      print('inside If');
      return Padding(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.blockSizeHorizontal * 8,
            SizeConfig.blockSizeHorizontal * 15,
            SizeConfig.blockSizeHorizontal * 8,
            SizeConfig.blockSizeHorizontal * 15),
        child: new Icon(
          Icons.add_a_photo,
          color: Colors.grey,
        ),
      );
    } else {
      print('inside else');
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
