import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/Product_Details.dart';
import 'package:flutter/material.dart';

class Single_Prod extends StatelessWidget {
  final String product_name;
  final String product_picture;
  final double product_price;
  final String product_description;
  final String product_category;
  final int product_quantity;
  final String product_id;

  Single_Prod({
    this.product_name,
    this.product_picture,
    this.product_price,
    this.product_category,
    this.product_description,
    this.product_quantity,
    this.product_id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 0.1),
        ],
      ),
      child: Card(
        elevation: 5,
        child: Hero(
          tag: product_name,
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new ProductDetails(
                        product_detail_name: product_name,
                        product_detail_picture: product_picture,
                        product_detail_price: product_price,
                        product_detail_category: product_category,
                        product_detail_description: product_description,
                        product_detail_quantity: product_quantity,
                        product_detail_id: product_id,
                      ))),
              child: GridTile(
                footer: Container(
                  height: SizeConfig.safeBlockVertical * 2.8,
                  color: Colors.white,
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Text(
                        product_name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                        ),
                      ),
                    ),
                    new Text(
                      "Rs.${product_price.round()} ",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.safeBlockVertical * 2.5,
                      ),
                    )
                  ]),
                ),
                child: Image.network(
                  product_picture,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: Loading2(),
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
