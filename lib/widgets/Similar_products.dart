import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/category_service.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:cafeteria/widgets/single_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SimilarProducts extends StatefulWidget {
  final category;
  final name;

  SimilarProducts({this.category, this.name});

  @override
  _SimilarProductsState createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  ProductServices _productServices = ProductServices();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  String cat;
  bool loading = false;

  void initState() {
    setState(() {
      cat = widget.category;
      loading = true;
    });
    _getProducts(categ: cat);
  }

  _getProducts({String categ}) async {
    List<DocumentSnapshot> data =
        await _productServices.getProductsByCategory(categ);

    setState(() {
      products = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading3()
        : Container(
            
            height: (products.length - 1) % 2 == 1
                ? SizeConfig.safeBlockVertical * 24.7 * ((products.length) / 2)
                : SizeConfig.safeBlockVertical *
                    24.7 *
                    (products.length - 1) /
                    2,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: (products.length) - 1,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                if (products[index].data['name'] == widget.name) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Single_Prod(
                      product_name:
                          products[(products.length) - 1].data['name'],
                      product_picture:
                          products[(products.length) - 1].data['imageUrl'],
                      product_price:
                          products[(products.length) - 1].data['price'],
                      product_category:
                          products[(products.length) - 1].data['category'],
                      product_description:
                          products[(products.length) - 1].data['description'],
                      product_quantity:
                          products[(products.length) - 1].data['quantity'],
                      product_id: products[(products.length) - 1].data['id'],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Single_Prod(
                      product_name: products[index].data['name'],
                      product_picture: products[index].data['imageUrl'],
                      product_price: products[index].data['price'],
                      product_category: products[index].data['category'],
                      product_description: products[index].data['description'],
                      product_quantity: products[index].data['quantity'],
                      product_id: products[index].data['id'],
                    ),
                  );
                }
              },
            ),
          );
  }
}
