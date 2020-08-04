import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/home_page.dart';
import 'package:cafeteria/screens/order_details.dart';
import 'package:cafeteria/screens/orders.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:cafeteria/services/order_services.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria/screens/Cart_products.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  OrderServices _orderServices = OrderServices();
  ProductServices _productServices = ProductServices();

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getProducts();
  }

  List<DocumentSnapshot> products = <DocumentSnapshot>[];

  getProducts() async {
    List<DocumentSnapshot> data = await _productServices.getProductsList();
    setState(() {
      products = data;
    });
  }

  final _key = GlobalKey<ScaffoldState>();

  bool loading = true;
  bool quan = true;

  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    if (user.userModel != null) {
      setState(() {
        loading = false;
      });
    }

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
              child: Text(
                'Cart',
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
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
              ),
              user.userModel.cart.isEmpty
                  ? new Container()
                  : new IconButton(
                      icon: Icon(
                        Icons.delete_sweep,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Are you sure to CLEAR Cart ?'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text('CLEAR',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    user.clearCart();
                                    user.reloadUserModel();
                                    _key.currentState.showSnackBar(SnackBar(
                                        content: Text('Cart Cleared...')));

                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text('NO',
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
          preferredSize: Size.fromHeight(
            SizeConfig.safeBlockVertical * 6.5,
          )),
      body: loading
          ? Loading()
          : user.userModel.cart.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'No Items in Cart...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: SizeConfig.blockSizeVertical * 2,
                          fontStyle: FontStyle.italic,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : new Cart_Products(),
      bottomNavigationBar: user.userModel.cart.isEmpty
          ? new Container(
              height: 60,
            )
          : Container(
              height: 60,

              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 0.1,
                  ),
                ],
              ),
              //color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: ListTile(
                    title: Row(
                      children: <Widget>[
                        new Text(
                          "Total",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.safeBlockVertical * 2.5,
                          ),
                        ),
                        SizedBox(width: SizeConfig.safeBlockVertical * 4),
                        new Text(
                          "Rs. ${user.userModel.totalCartPrice.round()}",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.safeBlockVertical * 2.5,
                          ),
                        ),
                      ],
                    ),
                  )),
                  Expanded(
                    child: new MaterialButton(
                      height: 60,
                      onPressed: () {
                        {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('Place Order ?'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text('Proceed',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        loading = true;
                                      });

                                      // QUANTITY CHECKING

                                      for (int i = 0;
                                          i < user.userModel.cart.length;
                                          i++) {
                                        for (int j = 0;
                                            j < products.length;
                                            j++) {
                                          if (user.userModel.cart[i]
                                                  ['productId'] ==
                                              products[j].data['id']) {
                                            if (user.userModel.cart[i]
                                                    ['quantity'] <=
                                                products[j].data['quantity']) {
                                              quantity =
                                                  products[j].data['quantity'] -
                                                      user.userModel.cart[i]
                                                          ['quantity'];
                                            } else {
                                              setState(() {
                                                quan = false;
                                              });
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title:
                                                        Text('Higher Quantity'),
                                                    content: Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .safeBlockVertical *
                                                              3,
                                                        ),
                                                        Text(
                                                            'Product Name:  ${products[j].data['name']}'),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .safeBlockVertical *
                                                              2,
                                                        ),
                                                        Text(
                                                            'Available Quantity:  ${products[j].data['quantity']}'),
                                                        Text(
                                                            'Cart Quantity:  ${user.userModel.cart[i]['quantity']}'),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .safeBlockVertical *
                                                              5,
                                                        ),
                                                        Text(
                                                            'Note:  Remove that product from cart and add within the range of Available Quantity')
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        }
                                      }

                                      // Quantity Checking Passed then

                                      if (quan) {
                                        var uuid = Uuid();
                                        String id = uuid.v4();

                                        // CREATE ORDER

                                        _orderServices.createOrder(
                                            userId: user.user.uid,
                                            id: id,
                                            status: "paid",
                                            totalPrice:
                                                user.userModel.totalCartPrice,
                                            cart: user.userModel.cart);

                                        // Quantity Updation

                                        for (int i = 0;
                                            i < user.userModel.cart.length;
                                            i++) {
                                          _productServices.quantityUpdate(
                                              quantity,
                                              user.userModel.cart[i]
                                                  ['productId']);
                                        }

                                        // Balance Part

                                        user.clearCart();
                                        user.reloadUserModel();

                                        _key.currentState.showSnackBar(SnackBar(
                                            content: Text('Cart Cleared...')));

                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: Text(
                                                  'Order Placed Successfully'),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderList()),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
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
                        }
                      },
                      child: new Text(
                        "Check out",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
