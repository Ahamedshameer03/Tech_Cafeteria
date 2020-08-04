import 'package:cafeteria/components/size_cofig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/Provider/user_provider.dart';

class Cart_Products extends StatefulWidget {
  @override
  _Cart_ProductsState createState() => _Cart_ProductsState();
}

class _Cart_ProductsState extends State<Cart_Products> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<UserProvider>(context);

    return new ListView.builder(
        itemCount: user.userModel.cart.length,
        itemBuilder: (context, index) {
          return Single_Cart_Product(
            cart_product_name: user.userModel.cart[index]['name'],
            cart_product_picture: user.userModel.cart[index]['imageUrl'],
            cart_product_price: user.userModel.cart[index]['price'],
            cart_product_quantity: user.userModel.cart[index]['quantity'],
            index: index,
          );
        });
  }
}

class Single_Cart_Product extends StatelessWidget {
  final String cart_product_name;
  final String cart_product_picture;
  final int cart_product_price;
  final int cart_product_quantity;
  final int index;
  final _key = GlobalKey<ScaffoldState>();

  Single_Cart_Product({
    this.cart_product_name,
    this.cart_product_picture,
    this.cart_product_price,
    this.cart_product_quantity,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListTile(
            leading: new Image.network(
              cart_product_picture,
              width: SizeConfig.safeBlockVertical * 10,
              height: SizeConfig.safeBlockVertical * 10,
            ),
            title: new Text(
              cart_product_name,
              style: TextStyle(
                fontSize: SizeConfig.safeBlockVertical * 2.5,
              ),
            ),
            subtitle: new Container(
              alignment: Alignment.topLeft,
              child: new Text(
                "$cart_product_price  x  $cart_product_quantity",
                //'price',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            trailing: Container(
              height: SizeConfig.safeBlockVertical * 10,
              width: SizeConfig.safeBlockVertical * 17.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Text(
                    'Rs. ${cart_product_price * cart_product_quantity}',
                    //'f',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.safeBlockVertical * 2.5,
                    ),
                  ),
                  new IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                  'Are you sure to Remove item from cart ?'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text('Remove !',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    user.removeFromCart(
                                        cartItem: user.userModel.cart[index]);
                                    user.reloadUserModel();

                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text('No',
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
