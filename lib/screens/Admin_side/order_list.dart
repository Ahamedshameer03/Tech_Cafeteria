import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/models/orders.dart';
import 'package:cafeteria/services/order_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  OrderServices _orderServices = OrderServices();
  List<DocumentSnapshot> orders = <DocumentSnapshot>[];
  bool loading = true;

  @override
  void initState() {
    getOrders();
  }

  getOrders() async {
    List<DocumentSnapshot> data = await _orderServices.getOrders();
    setState(() {
      orders = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading4()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text(
                "Order List",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('images/app_bac.jpg'),
                fit: BoxFit.fill,
              )),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        title: RichText(
                          text: TextSpan(
                              text: 'Order Id:  ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: orders[index].data['id'],
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                        ),
                        subtitle: Text(
                          '${orders[index].data['cart'].length}  Items',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              (DateFormat("MMM-dd, yyyy").format(
                                      orders[0].data['createdAt'].toDate()))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[50],
                              ),
                            ),
                            Text(
                              'Rs. ${orders[index].data['total']}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[50],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OrderDetails(
                                        id: orders[index].data['id'],
                                      )));
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}

class OrderDetails extends StatefulWidget {
  final String id;

  OrderDetails({this.id});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderServices _orderServices = OrderServices();

  bool loading = true;

  List<OrderModel> orders = [];
  OrderModel order;

  @override
  void initState() {
    getOrders();
  }

  getOrders() async {
    List<DocumentSnapshot> data =
        await _orderServices.getOrderById(orderId: widget.id);

    for (DocumentSnapshot data1 in data) {
      orders.add(OrderModel.fromSnapshot(data1));
    }
    setState(() {
      order = orders[0];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return loading
        ? Loading4()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text(
                "Order Details",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('images/app_bac.jpg'),
                  fit: BoxFit.fill,
                )),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                      fontSize:
                                          SizeConfig.safeBlockVertical * 2.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 9,
                        child: Card(
                          elevation: 5,
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
                                        text: ' ${order.id}',
                                        style: TextStyle(
                                          fontSize: 12,
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
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.safeBlockVertical * 1,
                                    ),
                                    Text(
                                      (DateFormat("MMM-dd, yyyy")
                                              .format(order.createdAt))
                                          .toString(),
                                      // order.createdAt.toLocal().toString(),
                                      style: TextStyle(
                                        fontSize: 17,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                      fontSize:
                                          SizeConfig.safeBlockVertical * 2.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical * 8,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  'User id: ${order.userId}',
                                  style: TextStyle(
                                    fontSize: 12,
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
                                        fontSize: 17,
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
                                        fontSize: 20,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                  'Ordered Items',
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockVertical * 2.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: SizeConfig.blockSizeVertical *
                            order.cart.length *
                            11.6,
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
                                            fontSize:
                                                SizeConfig.safeBlockVertical *
                                                    2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Row(
                                        children: <Widget>[
                                          Text(
                                            'Quantity: ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: SizeConfig
                                                        .safeBlockVertical *
                                                    1.9,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            order.cart[index]['quantity']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: SizeConfig
                                                        .safeBlockVertical *
                                                    1.9,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      trailing: Image.network(
                                        order.cart[index]['imageUrl'],
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      order.status == 'paid'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
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
                                        Colors.green,
                                        Colors.greenAccent,
                                        Colors.green,
                                      ],
                                    ),
                                  ),
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: MaterialButton(
                                      child: Text(
                                        'Deliver !',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        _orderServices.statusUpdate(
                                            orderId: order.id);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
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
                                        Colors.red,
                                        Colors.red,
                                        Colors.red[200],
                                        Colors.red,
                                        Colors.red,
                                      ],
                                    ),
                                  ),
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: MaterialButton(
                                      child: Text(
                                        'Delivered',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                )),
          );
  }
}
