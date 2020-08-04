import 'package:cafeteria/models/product.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  ProductServices _productService = ProductServices();

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
