import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  // Constants
  static const String ID = 'id';
  static const String CATEGORY = 'category';
  static const String NAME = 'name';
  static const String QUANTITY = 'quantity';
  static const String PRICE = 'price';
  static const String IMAGE = 'imageUrl';
  static const String DESCRIPTION = 'description';
  static const String FEATURED = 'featured';

  // local variables
  String _id;
  String _category;
  String _name;
  int _quantity;
  double _price;
  String _image;
  String _description;
  bool _featured;

  // getters
  String get id => _id;
  String get category => _category;
  String get name => _name;
  int get quantity => _quantity;
  double get price => _price;
  String get image => _image;
  String get description => _description;
  bool get featured => _featured;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data[ID];
    _name = snapshot.data[NAME];
    _category = snapshot.data[CATEGORY];
    _quantity = snapshot.data[QUANTITY];
    _price = snapshot.data[PRICE];
    _image = snapshot.data[IMAGE];
    _description = snapshot.data[DESCRIPTION];
    _featured = snapshot.data[FEATURED];
  }
}
