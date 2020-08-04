import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/Cart.dart';
import 'package:cafeteria/screens/home_page.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:cafeteria/widgets/Similar_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafeteria/models/product.dart';

class ProductDetails extends StatefulWidget {
  final String product_detail_name;
  final String product_detail_picture;
  final double product_detail_price;
  final int product_detail_quantity;
  final String product_detail_category;
  final String product_detail_description;
  final String product_detail_id;

  ProductDetails({
    this.product_detail_name,
    this.product_detail_picture,
    this.product_detail_category,
    this.product_detail_description,
    this.product_detail_quantity,
    this.product_detail_price,
    this.product_detail_id,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  bool favourite = false;

  ProductModel product;
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    SizeConfig().init(context);

    return Scaffold(
      key: _key,
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
              child: Icon(Icons.home),
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
              new IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cart(),
                      ),
                    );
                  }),
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
                child: Image.network(
                  widget.product_detail_picture,
                ),
              ),
              footer: new Container(
                color: Colors.white,
                child: ListTile(
                  leading: new Text(
                    widget.product_detail_name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.safeBlockVertical * 3,
                    ),
                  ),
                  title: new Text(
                    "Rs.${widget.product_detail_price.round()}",
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
                width: SizeConfig.safeBlockVertical * 7,
              ),
              quantity == 1
                  ? Container(
                      child: ClipOval(
                        child: Material(
                          elevation: 5,
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.red,
                            child: SizedBox(
                              width: SizeConfig.safeBlockVertical * 5,
                              height: SizeConfig.safeBlockVertical * 5,
                              child: Icon(
                                Icons.remove,
                              ),
                            ),
                            onTap: () {
                              if (quantity == 1) {
                              } else {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red.withOpacity(0.6),
                              spreadRadius: 3,
                              blurRadius: 3)
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipOval(
                        child: Material(
                          elevation: 5,
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.red,
                            child: SizedBox(
                              width: SizeConfig.safeBlockVertical * 5,
                              height: SizeConfig.safeBlockVertical * 5,
                              child: Icon(
                                Icons.remove,
                              ),
                            ),
                            onTap: () {
                              if (quantity != 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                width: SizeConfig.safeBlockVertical * 2.5,
              ),
              Expanded(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  height: SizeConfig.safeBlockVertical * 7,
                  onPressed: () async {
                    if (quantity >= 1) {
                      bool value = await user.addToCart(
                        quantity: quantity,
                        product_id: widget.product_detail_id,
                        product_name: widget.product_detail_name,
                        product_price: widget.product_detail_price.round(),
                        product_imageUrl: widget.product_detail_picture,
                      );
                      user.reloadUserModel();
                      setState(() {
                        quantity = 1;
                      });

                      if (value) {
                        _key.currentState.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: new Text('Added to Cart !'),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: ButtonTheme(
                                      height: SizeConfig.safeBlockVertical * 1,
                                      child: new FlatButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Cart()));
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'View Cart  ',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Icon(
                                                Icons.shopping_cart,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          )),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: quantity > 1
                      ? new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              'Add  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2.5,
                              ),
                            ),
                            new Text(
                              quantity.toString(),
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 3.5,
                              ),
                            ),
                            new Text(
                              '  to Cart',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2.5,
                              ),
                            ),
                          ],
                        )
                      : new Text(
                          'Add to Cart',
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
              quantity == widget.product_detail_quantity
                  ? Container(
                      child: ClipOval(
                        child: Material(
                          //elevation: 5,
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.red,
                            child: SizedBox(
                              width: SizeConfig.safeBlockVertical * 5,
                              height: SizeConfig.safeBlockVertical * 5,
                              child: Icon(
                                Icons.add,
                              ),
                            ),
                            onTap: () {
                              if (quantity != widget.product_detail_quantity) {
                                setState(() {
                                  quantity++;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red.withOpacity(0.6),
                              spreadRadius: 3,
                              blurRadius: 3)
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipOval(
                        child: Material(
                          //elevation: 5,
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.red,
                            child: SizedBox(
                              width: SizeConfig.safeBlockVertical * 5,
                              height: SizeConfig.safeBlockVertical * 5,
                              child: Icon(
                                Icons.add,
                              ),
                            ),
                            onTap: () {
                              if (quantity == widget.product_detail_quantity) {
                                print('error');
                                print(quantity);
                              } else {
                                setState(() {
                                  quantity++;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                width: SizeConfig.safeBlockVertical * 7,
              ),
            ],
          ),
          Divider(),
          new Padding(
            padding: const EdgeInsets.all(8),
            child: new Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockVertical * 2.5,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: SizeConfig.safeBlockVertical * 4,
              ),
              Text(
                widget.product_detail_description,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2,
                ),
              ),
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
          SimilarProducts(
            category: widget.product_detail_category,
            name: widget.product_detail_name,
          ),
        ],
      ),
    );
  }
}
