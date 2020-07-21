import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/home_page.dart';
import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/widgets/Similar_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    SizeConfig().init(context);
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
              child: Text(
                'Cafeteria',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.safeBlockVertical * 2.5,
                ),
              ),
            ),
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
          preferredSize: Size.fromHeight(
            SizeConfig.safeBlockVertical * 6.5,
          )),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: SizeConfig.safeBlockVertical * 40,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.asset(
                  widget.product_detail_picture,
                ),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(
                    widget.product_detail_name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.safeBlockVertical * 3,
                    ),
                  ),
                  title: new Text(
                    "Rs.${widget.product_detail_price}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: SizeConfig.safeBlockVertical * 3,
                    ),
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
                              title: new Text('Quantity',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.safeBlockVertical * 2,
                                  )),
                              content: new Text('Choose the quantity',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockVertical * 2,
                                  )),
                              actions: <Widget>[
                                new MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(context);
                                  },
                                  child: new Text('close',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockVertical * 2,
                                      )),
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
                          child: new Text('Quantity',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              )),
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
                width: SizeConfig.safeBlockVertical * 2.5,
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.red,
                  textColor: Colors.white,
                  child: new Text(
                    'Buy Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.safeBlockVertical * 2.5,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.safeBlockVertical * 2.5,
              ),
              new IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    size: SizeConfig.safeBlockVertical * 3,
                  ),
                  color: Colors.red,
                  onPressed: () {}),
              new IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    size: SizeConfig.safeBlockVertical * 3,
                  ),
                  color: Colors.red,
                  onPressed: () {})
            ],
          ),
          Divider(),
          new Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
            child: new Text(
              'Similar Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockVertical * 2.5,
              ),
            ),
          ),

          //Grid View
          Container(
            height: SizeConfig.safeBlockVertical * 50,
            child: SimilarProducts(),
          ),
        ],
      ),
    );
  }
}
