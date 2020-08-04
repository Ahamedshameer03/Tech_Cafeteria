import 'dart:io';

import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/category_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  CategoryService _categoryService = CategoryService();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  File _image;

  bool loading = false;
  bool state = false;
  bool noImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Add Category",
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
                      Divider(),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
                        child: TextFormField(
                          controller: categoryController,
                          decoration: InputDecoration(
                              hintText: 'Enter Category Name',
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
                              return 'You must enter the Category name';
                            } else if (value.length > 15) {
                              return 'Category name cannot have more that 15 characters';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 5,
                      ),
                      FlatButton(
                        onPressed: () {
                          validateAndUpload();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Add Category',
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
        final String picture = "${categoryController.text}.jpg";
        StorageUploadTask task =
            storage.ref().child("Category/$picture").putFile(_image);

        StorageTaskSnapshot snapshot =
            await task.onComplete.then((snapshot) => snapshot);

        task.onComplete.then((snapshot) async {
          imageUrl = await snapshot.ref.getDownloadURL();

          _categoryService.createCategory(categoryController.text, imageUrl);
          _formKey.currentState.reset();
          setState(() {
            loading = false;
          });
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(
                      'Category "${categoryController.text}" Added Successfully'),
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
    setState(() {
      loading = false;
    });
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

  void _selectImage(Future<File> pickImage) async {
    _image = await pickImage;
    setState(() {
      loading = true;
    });
    _displayChild();
  }
}
