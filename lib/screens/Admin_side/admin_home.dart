import 'package:cafeteria/screens/Admin_side/QR_Scan.dart';
import 'package:cafeteria/screens/Admin_side/category_list.dart';
import 'package:cafeteria/screens/Admin_side/new_category.dart';
import 'package:cafeteria/screens/Admin_side/product_list.dart';
import 'package:cafeteria/screens/Admin_side/user_list.dart';
import 'package:cafeteria/services/category_service.dart';
import 'package:cafeteria/screens/Admin_side/new_product.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/order_services.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:cafeteria/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final UserProvider _auth = UserProvider.initialize();

  MaterialColor active = Colors.indigo;
  Color notActive = Colors.white;
  String category;

  PageController _pageController = PageController();

  bool loading = false;
  bool page = true;

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> users = <DocumentSnapshot>[];
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  List<DocumentSnapshot> orders = <DocumentSnapshot>[];

  @override
  void initState() {
    _getDetails();
  }

  _getDetails() async {
    List<DocumentSnapshot> data1 = await _categoryService.getCategories();
    List<DocumentSnapshot> data2 = await _productServices.getProductsList();
    List<DocumentSnapshot> data3 = await _userServices.getUsers();
    List<DocumentSnapshot> data4 = await _orderServices.getOrders();

    setState(() {
      categories = data1;
      products = data2;
      users = data3;
      orders = data4;

      if (users.length != 0 &&
          products.length != 0 &&
          categories.length != 0 &&
          orders.length != 0) {
        setState(() {
          state = false;
        });
      }
    });
  }

  UserServices _userServices = UserServices();
  CategoryService _categoryService = CategoryService();
  ProductServices _productServices = ProductServices();
  OrderServices _orderServices = OrderServices();

  int pageChanged = 0;

  bool state = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.blue,
        title: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton.icon(
                color: pageChanged == 0 ? (Colors.indigo) : (Colors.blue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  _pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                icon: Icon(
                  Icons.dashboard,
                  color: pageChanged == 0 ? notActive : active,
                ),
                label: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: pageChanged == 0
                        ? (SizeConfig.safeBlockVertical * 2)
                        : (SizeConfig.safeBlockVertical * 1.5),
                    fontWeight: FontWeight.bold,
                    color: pageChanged == 0 ? notActive : active,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FlatButton.icon(
                color: pageChanged == 0 ? (Colors.blue) : (Colors.indigo),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
                icon: Icon(
                  Icons.sort,
                  size: pageChanged == 1
                      ? (SizeConfig.safeBlockVertical * 2)
                      : (SizeConfig.safeBlockVertical * 1.5),
                  color: pageChanged == 1 ? notActive : active,
                ),
                label: Text(
                  'Manage',
                  style: TextStyle(
                    fontSize: pageChanged == 1
                        ? (SizeConfig.safeBlockVertical * 2)
                        : (SizeConfig.safeBlockVertical * 1.5),
                    fontWeight: FontWeight.bold,
                    color: pageChanged == 1 ? notActive : active,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/app_bac.jpg'),
          fit: BoxFit.fill,
        )),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              pageChanged = index;
            });
          },
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockVertical * 3),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7)
                            ],
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.indigo,
                                Colors.blueAccent,
                                Colors.indigo,
                              ],
                            ),
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QRscan()));
                              },
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.shopping_basket,
                                    size: SizeConfig.blockSizeHorizontal * 5,
                                    color: Colors.white70,
                                  ),
                                  Text(
                                    " Orders",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.6,
                                    ),
                                  )
                                ],
                              ),
                              subtitle: state
                                  ? Text(
                                      'loading...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.blockSizeVertical * 2),
                                    )
                                  : Text(
                                      orders.length.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.safeBlockVertical * 7),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockVertical * 3),
                        child: Container(
                          //height: SizeConfig.safeBlockVertical * 2,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7)
                            ],
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.indigo,
                                Colors.blueAccent,
                                Colors.indigo,
                              ],
                            ),
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CategoryList()));
                              },
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.category,
                                    size: SizeConfig.blockSizeHorizontal * 5,
                                    color: Colors.white70,
                                  ),
                                  Text(
                                    " Categories",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.6,
                                    ),
                                  )
                                ],
                              ),
                              subtitle: state
                                  ? Text(
                                      'loading...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.blockSizeVertical * 2),
                                    )
                                  : Text(
                                      categories.length.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.safeBlockVertical * 7),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockVertical * 3),
                        child: Container(
                          //height: SizeConfig.safeBlockVertical * 2,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7)
                            ],
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.indigo,
                                Colors.blueAccent,
                                Colors.indigo,
                              ],
                            ),
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProductList()));
                              },
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.track_changes,
                                    size: SizeConfig.blockSizeHorizontal * 5,
                                    color: Colors.white70,
                                  ),
                                  Text(
                                    " Products",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.6,
                                    ),
                                  )
                                ],
                              ),
                              subtitle: state
                                  ? Text(
                                      'loading...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.blockSizeVertical * 2),
                                    )
                                  : Text(
                                      products.length.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.safeBlockVertical * 7),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.safeBlockVertical * 3),
                        child: Container(
                          //height: SizeConfig.safeBlockVertical * 2,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7)
                            ],
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.indigo,
                                Colors.blueAccent,
                                Colors.indigo,
                              ],
                            ),
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => UserList()));
                              },
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.people,
                                    size: SizeConfig.blockSizeHorizontal * 5,
                                    color: Colors.white70,
                                  ),
                                  Text(
                                    " Users",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.6,
                                    ),
                                  )
                                ],
                              ),
                              subtitle: state
                                  ? Text(
                                      'loading...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.blockSizeVertical * 2),
                                    )
                                  : Text(
                                      users.length.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.safeBlockVertical * 7),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            //_loadScreen(),
            ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.indigo,
                          Colors.blueAccent,
                          Colors.indigo,
                        ],
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white70,
                      ),
                      title: Text(
                        "Add Product",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AddProduct()));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.indigo,
                          Colors.blueAccent,
                          Colors.indigo,
                        ],
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.change_history,
                        color: Colors.white70,
                      ),
                      title: Text(
                        "Product List",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProductList()));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                Divider(
                  thickness: 1.0,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.indigo,
                          Colors.blueAccent,
                          Colors.indigo,
                        ],
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white70,
                      ),
                      title: Text(
                        "Add Category",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AddCategory()));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.indigo,
                          Colors.blueAccent,
                          Colors.indigo,
                        ],
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.category,
                        color: Colors.white70,
                      ),
                      title: Text(
                        "Category List",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => CategoryList()));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                Divider(
                  thickness: 1.0,
                ),
                // SizedBox(
                //   height: SizeConfig.safeBlockVertical * 1,
                // ),
                // Padding(
                //   padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //             color: Colors.black.withOpacity(0.5),
                //             spreadRadius: 2,
                //             blurRadius: 2)
                //       ],
                //       borderRadius: BorderRadius.circular(20),
                //       gradient: LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [
                //           Colors.indigo,
                //           Colors.blueAccent,
                //           Colors.indigo,
                //         ],
                //       ),
                //     ),
                //     child: ListTile(
                //       leading: Icon(
                //         Icons.shopping_basket,
                //         color: Colors.white70,
                //       ),
                //       title: Text(
                //         "Order List",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       onTap: () {
                //         Navigator.push(context,
                //             MaterialPageRoute(builder: (_) => OrderList()));
                //       },
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: SizeConfig.safeBlockVertical * 1,
                // ),
                // Divider(
                //   thickness: 1.0,
                // ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.indigo,
                          Colors.blueAccent,
                          Colors.indigo,
                        ],
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.people,
                        color: Colors.white70,
                      ),
                      title: Text(
                        "User List",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => UserList()));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                Divider(
                  thickness: 1.0,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.indigo,
                          Colors.blueAccent,
                          Colors.indigo,
                        ],
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.white70,
                      ),
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title:
                                    Text('Are you really want to Sign Out ?'),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text('Sign Out !',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      await _auth.signOut();
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
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), //_loadScreen(),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.green, spreadRadius: 4, blurRadius: 5)
          ],
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.indigo,
              Colors.blueAccent,
              Colors.indigo,
            ],
          ),
        ),
        child: FloatingActionButton(
            elevation: 0,
            child: Icon(
              Icons.camera,
              color: Colors.white70,
            ),
            backgroundColor: Colors.transparent,
            onPressed: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => QRscan()));
            }),
      ),
    );
  }

  String scanResult = "";

  Future scanQR() async {
    String str = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.QR,
    );
    setState(() {
      scanResult = str;
    });
  }
}
