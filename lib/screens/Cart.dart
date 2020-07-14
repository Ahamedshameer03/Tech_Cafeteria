import 'package:flutter/material.dart';
import 'package:cafeteria/components/Cart_products.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0.1,
          title: Text('Cart'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(255, 123, 67, 1.0),
                  Color.fromRGBO(245, 50, 111, 1.0),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
        ),
        preferredSize: Size.fromHeight(50.0),
      ),
      body: new Cart_Products(),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              title: new Text("Total"),
              subtitle: new Text("Rs.${230}"),
            )),
            Expanded(
              child: new MaterialButton(
                onPressed: () {},
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
