import 'package:flutter/material.dart';

class Cart_Products extends StatefulWidget {
  @override
  _Cart_ProductsState createState() => _Cart_ProductsState();
}

class _Cart_ProductsState extends State<Cart_Products> {
  var Product_on_the_cart = [
    {
      "name": "Dosa",
      "picture": "images/Tiffen/Dosa.png",
      "price": "20",
      "quantity": "5",
    },
    {
      "name": "Tea",
      "picture": "images/Drinks/Tea.png",
      "price": "10",
      "quantity": "5",
    },
    {
      "name": "Ice Cream",
      "picture": "images/Snacks/ice_cream.png",
      "price": "15",
      "quantity": "5",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: Product_on_the_cart.length,
        itemBuilder: (context, index) {
          return Single_Cart_Product(
            cart_product_name: Product_on_the_cart[index]["name"],
            cart_product_picture: Product_on_the_cart[index]["picture"],
            cart_product_price: Product_on_the_cart[index]["price"],
            cart_product_quantity: Product_on_the_cart[index]["quantity"],
          );
        });
  }
}

class Single_Cart_Product extends StatelessWidget {
  final cart_product_name;
  final cart_product_picture;
  final cart_product_price;
  final cart_product_quantity;

  Single_Cart_Product(
      {this.cart_product_name,
      this.cart_product_picture,
      this.cart_product_price,
      this.cart_product_quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: new Image.asset(
            cart_product_picture,
            width: 80,
            height: 80,
          ),
          title: new Text(cart_product_name),
          subtitle: new Container(
            alignment: Alignment.topLeft,
            child: new Text(
              "Rs.$cart_product_price",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          trailing: new Container(
            height: 100,
            width: 120,
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  color: Colors.green,
                  onPressed: () {},
                ),
                new Text(
                  cart_product_quantity,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                new IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          )),
    );
  }
}
