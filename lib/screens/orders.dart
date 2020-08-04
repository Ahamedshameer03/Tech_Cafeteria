import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/order_details.dart';
import 'package:intl/intl.dart';
import 'package:cafeteria/models/orders.dart';
import 'package:cafeteria/screens/home_page.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });
  }

  bool loading = false;

  List<OrderModel> order = <OrderModel>[];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<UserProvider>(context);

    user.getOrders();

    setState(() {
      loading = false;
    });

    return loading
        ? Loading3()
        : Scaffold(
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
                      'My Orders',
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
                        Icons.rotate_left,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          loading = true;
                          loading = false;
                        });
                      },
                    ),
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
            body: ListView.builder(
                itemCount: user.orders.length,
                itemBuilder: (_, index) {
                  OrderModel order = user.orders[index];
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderScreen(
                                  order: order,
                                ),
                              ),
                            );
                          },
                          leading: Icon(Icons.shopping_basket),
                          title: order.cart.length == 1
                              ? Text('${order.cart.length} Item',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.safeBlockVertical * 2,
                                  ))
                              : Text('${order.cart.length} Items',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.safeBlockVertical * 2,
                                  )),
                          subtitle: Row(
                            children: <Widget>[
                              Text('Ordered at   '),
                              Text(
                                (DateFormat("MMM-dd, yyyy")
                                        .format(order.createdAt))
                                    .toString(),
                                // order.createdAt.toLocal().toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 1.7,
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Rs. ${order.total}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.safeBlockVertical * 2.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  order.status,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
