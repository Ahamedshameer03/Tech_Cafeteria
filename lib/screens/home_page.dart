import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/screens/Cart.dart';
import 'package:cafeteria/services/Provider/app_provider.dart';
import 'package:cafeteria/services/Provider/product_provider.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cafeteria/widgets/Horizontal_ListView.dart';
import 'package:cafeteria/widgets/products.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserProvider user = UserProvider.initialize();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);
    //final productProvider = Provider.of<ProductProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    SizeConfig().init(context);
    Widget image_carousel = new Container(
      height: SizeConfig.blockSizeVertical * 30,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/carousel_1.jpeg'),
          AssetImage('images/carousel_2.jpeg'),
          AssetImage('images/carousel_3.jpeg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        dotBgColor: Colors.transparent,
        dotColor: Colors.black,
      ),
    );
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            elevation: 0.1,
            title: Text(
              'Cafeteria',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockVertical * 2.5,
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
              new IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => new Cart()));
                  }),
            ],
          ),
          preferredSize: Size.fromHeight(
            SizeConfig.safeBlockVertical * 6.5,
          )),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(
                _user.userModel.name ?? "username loading...",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                _user.userModel.email ?? "email loading...",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
              decoration: BoxDecoration(color: Colors.red),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: ListTile(
                title: Text('Home'),
                leading: Icon(
                  Icons.home,
                  color: Color.fromRGBO(255, 13, 239, 1),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My account'),
                leading: Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My orders'),
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.green,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('About'),
                leading: Icon(
                  Icons.help_outline,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text('Are you really want to Sign Out ?'),
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
                              await user.signOut();
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
              child: ListTile(
                title: Text('Sign Out'),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: new ListView(
        children: <Widget>[
          //Image Carousel
          image_carousel,

          //Padding Widget
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockVertical * 2.5,
              ),
            ),
          ),

          //Horizontal ListView
          HorizontalList(),
          //Text(appProvider.products.length.toString()),

          //Padding Widget
          new Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
            child: new Text(
              'Recent Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockVertical * 2.5,
              ),
            ),
          ),

          //Grid View
          Container(
            height: SizeConfig.safeBlockVertical * 50,
            child: Products(),
          )
        ],
      ),
    );
  }
}
