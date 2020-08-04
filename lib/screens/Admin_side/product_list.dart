import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<DocumentSnapshot> products = <DocumentSnapshot>[];
  ProductServices _productServices = ProductServices();

  bool loading = true;

  @override
  void initState() {
    _getProducts();
  }

  _getProducts() async {
    List<DocumentSnapshot> data = await _productServices.getProductsList();
    setState(() {
      products = data;
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
                "Product List",
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
                itemCount: products.length,
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
                        title: Text(
                          products[index].data['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Image.network(
                          products[index].data['imageUrl'],
                          height: SizeConfig.safeBlockVertical * 6,
                          width: SizeConfig.safeBlockVertical * 6,
                          fit: BoxFit.contain,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProductDetail(
                                        product_detail_picture:
                                            products[index].data['imageUrl'],
                                        product_detail_name:
                                            products[index].data['name'],
                                        product_detail_category:
                                            products[index].data['category'],
                                        product_detail_price:
                                            products[index].data['price'],
                                        product_detail_quantity:
                                            products[index].data['quantity'],
                                        product_detail_featured:
                                            products[index].data['featured'],
                                        product_detail_id:
                                            products[index].data['id'],
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

class ProductDetail extends StatefulWidget {
  final product_detail_name;
  final product_detail_picture;
  final product_detail_price;
  final product_detail_quantity;
  final product_detail_category;
  final product_detail_featured;
  final product_detail_id;

  ProductDetail({
    this.product_detail_name,
    this.product_detail_featured,
    this.product_detail_picture,
    this.product_detail_price,
    this.product_detail_quantity,
    this.product_detail_category,
    this.product_detail_id,
  });

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity;
  GlobalKey<FormState> _quantityFormKey = GlobalKey();
  ProductServices _productServices = ProductServices();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    String url = "Products/${widget.product_detail_name}.jpg";
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(url);
    SizeConfig().init(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text(
                "Product Details",
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: RichText(
                              text: TextSpan(
                                  text: 'Are you sure to  ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2),
                                  children: [
                                    TextSpan(
                                      text: 'DELETE ',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize:
                                              SizeConfig.blockSizeVertical * 2),
                                    ),
                                    TextSpan(
                                      text: '"${widget.product_detail_name}"',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              SizeConfig.blockSizeVertical * 2),
                                    ),
                                  ]),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text('DELETE PRODUCT',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  storageReference.delete();

                                  _productServices
                                      .deleteProduct(widget.product_detail_id);

                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          content: Text(
                                              'Product "${widget.product_detail_name}" deleted Successfully'),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              child: Text('OK',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
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
                    }
                  },
                )
              ],
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('images/app_bac.jpg'),
                fit: BoxFit.fill,
              )),
              child: new ListView(
                children: <Widget>[
                  new Container(
                    color: Colors.transparent,
                    height: SizeConfig.safeBlockVertical * 40,
                    child: GridTile(
                      child: Container(
                        color: Colors.transparent,
                        child: Image.network(
                          widget.product_detail_picture,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                  ),
                  Divider(),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.8),
                    child: Column(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            Text(
                              "Product Name :",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockVertical * 2,
                            ),
                            Text(
                              widget.product_detail_name,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        new Row(
                          children: <Widget>[
                            Text(
                              "Product Category :",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockVertical * 2,
                            ),
                            Text(
                              widget.product_detail_category,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        new Row(
                          children: <Widget>[
                            Text(
                              "Product Quantity :",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockVertical * 2,
                            ),
                            Text(
                              "${widget.product_detail_quantity.toString()} Nos",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _quantityAlert(widget.product_detail_id);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        new Row(
                          children: <Widget>[
                            Text(
                              "Product Price :",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockVertical * 2,
                            ),
                            Text(
                              "Rs. ${widget.product_detail_price.toString()}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        new Row(
                          children: <Widget>[
                            Text(
                              "Popular Product :",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockVertical * 2,
                            ),
                            InkWell(
                              child: widget.product_detail_featured
                                  ? Row(
                                      children: <Widget>[
                                        Text(
                                          'YES',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.safeBlockVertical *
                                                    2,
                                          ),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.safeBlockVertical,
                                        ),
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: <Widget>[
                                        Text(
                                          'NO',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.safeBlockVertical *
                                                    2,
                                          ),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.safeBlockVertical,
                                        ),
                                        Icon(
                                          Icons.highlight_off,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockVertical,
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _featuredAlert(widget.product_detail_id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  void _featuredAlert(String id) {
    bool state;
    state = widget.product_detail_featured;
    var alert = new AlertDialog(
      title: Text('Featured Update'),
      content: state
          ? RichText(
              text: TextSpan(
                  text: 'Are you sure to Update this Product as ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.blockSizeVertical * 2),
                  children: [
                    TextSpan(
                      text: 'NOT Featured ?',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: SizeConfig.blockSizeVertical * 2),
                    ),
                  ]),
            )
          : RichText(
              text: TextSpan(
                  text: 'Are you sure to Update this Product as ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.blockSizeVertical * 2),
                  children: [
                    TextSpan(
                      text: 'Featured ?',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: SizeConfig.blockSizeVertical * 2),
                    ),
                  ]),
            ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (state) {
                _productServices.featureUpdate(!state, id);

                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Center(
                          child: RichText(
                            text: TextSpan(
                                text: 'Product Updated as ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: SizeConfig.blockSizeVertical * 2),
                                children: [
                                  TextSpan(
                                    text: 'NOT Featured',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              } else {
                _productServices.featureUpdate(!state, id);

                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Center(
                          child: RichText(
                            text: TextSpan(
                                text: 'Product Updated as ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.blockSizeVertical * 2,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Featured',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              }
            },
            child: Text('UPDATE')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void _quantityAlert(String id) {
    var alert = new AlertDialog(
      title: Text('Quantity Update'),
      content: Form(
        key: _quantityFormKey,
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          onChanged: (textValue) {
            setState(() {
              quantity = int.parse(textValue);
            });
          },
          validator: (textValue) {
            if (textValue.isEmpty) {
              return 'quantity cannot be EMPTY';
            }
            return null;
          },
          decoration: InputDecoration(hintText: "Quantity"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (_quantityFormKey.currentState.validate()) {
                if (quantity != null) {
                  _productServices.quantityUpdate(quantity, id);
                  quantity = null;

                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text('Quantity Updated Successfully'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                } else {}
              }
            },
            child: Text('UPDATE')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}
