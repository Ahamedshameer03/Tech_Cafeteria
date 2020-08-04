import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/models/orders.dart';
import 'package:cafeteria/screens/home_page.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cafeteria/components/loading.dart';

class OrderScreen extends StatelessWidget {
  OrderModel order;

  OrderScreen({this.order});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<UserProvider>(context);

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
                'Order Details',
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
            ],
          ),
          preferredSize: Size.fromHeight(
            SizeConfig.safeBlockVertical * 6.5,
          )),
      body: Container(
        height: SizeConfig.blockSizeVertical * 100,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: SizeConfig.safeBlockVertical * 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(255, 123, 67, 1.0),
                        Color.fromRGBO(245, 50, 111, 1.0),
                      ],
                    )),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Order details',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 2.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: SizeConfig.safeBlockVertical * 12,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      title: RichText(
                          text: TextSpan(
                              text: 'Order id: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              children: <InlineSpan>[
                            TextSpan(
                              text: ' ${order.id.toString()}',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 2,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ])),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Ordered at',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 1,
                          ),
                          Text(
                            (DateFormat("MMM-dd, yyyy").format(order.createdAt))
                                .toString(),
                            // order.createdAt.toLocal().toString(),
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: SizeConfig.safeBlockVertical * 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(255, 123, 67, 1.0),
                      Color.fromRGBO(245, 50, 111, 1.0),
                    ],
                  )),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'User details',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: SizeConfig.safeBlockVertical * 13,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'User Name: ${user.userModel.name}',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'User id: ${order.userId}',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 1.7,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Order Total',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 1,
                          ),
                          Text(
                            'Rs. ${order.total}',
                            // order.createdAt.toLocal().toString(),
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: QrImage(
                  backgroundColor: Colors.white,
                  data: order.id.toString(),
                  size: SizeConfig.safeBlockVertical * 15),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: SizeConfig.safeBlockVertical * 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(255, 123, 67, 1.0),
                      Color.fromRGBO(245, 50, 111, 1.0),
                    ],
                  )),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Ordered Item(s)',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: SizeConfig.blockSizeVertical * order.cart.length * 14,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order.cart.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              '${order.cart[index]['name'].toString()}  (Rs. ${order.cart[index]['price'].toString()})',
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical * 2,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          SizeConfig.safeBlockVertical * 1.9,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  order.cart[index]['quantity'].toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          SizeConfig.safeBlockVertical * 1.9,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: Image.network(
                              order.cart[index]['imageUrl'],
                              height: SizeConfig.safeBlockVertical * 10,
                              width: SizeConfig.safeBlockVertical * 10,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: Loading2(),
                                );
                              },
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
