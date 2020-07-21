import 'package:cafeteria/services/add_product.dart';
import 'package:cafeteria/models/product.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  ProductService _productService = ProductService();

  AppProvider() {
    _getProducts();
  }

  // getter
  List<ProductModel> get products => _products;

  // methods
  void _getProducts() async {
    _products = await _productService.getProducts();
    notifyListeners();
  }
}
