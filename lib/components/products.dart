import 'package:flutter/material.dart';
import 'package:cafeteria/screens/Product_Details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_list = [
    {
      "name": "Dosa",
      "picture": "images/Tiffen/Dosa.png",
      "price": "20",
    },
    {
      "name": "Tea",
      "picture": "images/Drinks/Tea.png",
      "price": "10",
    },
    {
      "name": "Cool Drinks",
      "picture": "images/Drinks/Cooldrinks.png",
      "price": "15",
    },
    {
      "name": "Ice Cream",
      "picture": "images/Snacks/ice_cream.png",
      "price": "15",
    },
    {
      "name": "Coffee",
      "picture": "images/Drinks/Coffee.png",
      "price": "10",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: product_list.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Single_Prod(
          product_name: product_list[index]['name'],
          product_picture: product_list[index]['picture'],
          product_price: product_list[index]['price'],
        );
      },
    );
  }
}

class Single_Prod extends StatelessWidget {
  final product_name;
  final product_picture;
  final product_price;

  Single_Prod({this.product_name, this.product_picture, this.product_price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: product_name,
        child: Material(
          child: InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ProductDetails(
                      product_detail_name: product_name,
                      product_detail_picture: product_picture,
                      product_detail_price: product_price,
                    ))),
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: Row(children: <Widget>[
                  Expanded(
                    child: Text(
                      product_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  new Text(
                    "Rs.$product_price",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                ]),
              ),
              child: Image.asset(
                product_picture,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
