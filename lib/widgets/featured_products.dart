import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:cafeteria/widgets/single_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeaturedProducts extends StatefulWidget {
  @override
  _FeaturedProductsState createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  ProductServices _productServices = ProductServices();

  @override
  void initState() {
    //super.initState();
    _getProducts();
  }

  _getProducts() async {
    List<DocumentSnapshot> data = await _productServices.getFeaturedProducts();

    setState(() {
      products = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      height: products.length % 2 == 1
          ? SizeConfig.safeBlockVertical * 24 * ((products.length + 1) / 2)
          : SizeConfig.safeBlockVertical * 24 * (products.length / 2),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
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
        },
      ),
    );
  }
}
