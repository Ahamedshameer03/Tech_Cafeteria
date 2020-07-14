import 'package:cafeteria/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria/components/Similar_products.dart';

class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_picture;
  final product_detail_price;

  ProductDetails(
      {this.product_detail_name,
      this.product_detail_picture,
      this.product_detail_price});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            elevation: 0.1,
            title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
                child: Text('Cafeteria')),
            flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(255, 123, 67, 1.0),
                Color.fromRGBO(245, 50, 111, 1.0),
              ],
            ))),
            actions: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            ],
          ),
          preferredSize: Size.fromHeight(50.0)),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 250,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.asset(widget.product_detail_picture),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(
                    widget.product_detail_name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
                  title: new Text(
                    "Rs.${widget.product_detail_price}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              SizedBox(
                width: 90,
              ),
              Expanded(
                child: MaterialButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: new Text('Quantity'),
                              content: new Text('Choose the quantity'),
                              actions: <Widget>[
                                new MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(context);
                                  },
                                  child: new Text('close'),
                                )
                              ],
                            );
                          });
                    },
                    color: Colors.white,
                    textColor: Colors.grey,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: new Text('Quantity'),
                        ),
                        Expanded(child: new Icon(Icons.arrow_drop_down))
                      ],
                    )),
              ),
              SizedBox(
                width: 90,
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.red,
                  textColor: Colors.white,
                  child: new Text('Buy Now'),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              new IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  color: Colors.red,
                  onPressed: () {}),
              new IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {})
            ],
          ),
          Divider(),
          new Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
            child: new Text('Similar Products'),
          ),

          //Grid View
          Container(
            height: 320.0,
            child: SimilarProducts(),
          ),
        ],
      ),
    );
  }
}
