import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/Product_Details.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:flutter/material.dart';

String capitalize(String s) =>
    s[0].toUpperCase() + s.substring(1).toLowerCase();

class Search extends SearchDelegate {
  List<Product> lists;

  Search({this.lists});

  List<Product> loadList() {
    List<Product> list = <Product>[];
    for (int i = 0; i < lists.length; i++) {
      list.add(Product(
        id: lists[i].id,
        name: lists[i].name,
        category: lists[i].category,
        description: lists[i].description,
        imageUrl: lists[i].imageUrl,
        price: lists[i].price,
        quantity: lists[i].quantity,
      ));
    }
    return list;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    SizeConfig().init(context);
    final mylist = query.isEmpty
        ? loadList()
        : loadList()
            .where(((p) => p.name.startsWith(capitalize(query))))
            .toList();
    print(mylist.length);
    return query.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'Search Products ...',
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
        : mylist.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'No Products Found ...',
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
            : ListView.builder(
                itemCount: mylist.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          mylist[index].name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.blockSizeVertical * 2,
                            //fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                              text: 'from   ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: SizeConfig.blockSizeVertical * 1.2,
                                fontStyle: FontStyle.italic,
                                //fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: mylist[index].category,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.5,
                                    //fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                        ),
                        trailing: Container(
                          width: SizeConfig.safeBlockVertical * 6,
                          height: SizeConfig.safeBlockVertical * 6,
                          child: Image.network(
                            mylist[index].imageUrl,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: Loading2(),
                              );
                            },
                            fit: BoxFit.fill,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new ProductDetails(
                                    product_detail_name: mylist[index].name,
                                    product_detail_picture:
                                        mylist[index].imageUrl,
                                    product_detail_price: mylist[index].price,
                                    product_detail_category:
                                        mylist[index].category,
                                    product_detail_description:
                                        mylist[index].description,
                                    product_detail_quantity:
                                        mylist[index].quantity,
                                    product_detail_id: mylist[index].id,
                                  )));
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    SizeConfig().init(context);
    final mylist = query.isEmpty
        ? loadList()
        : loadList()
            .where(((p) => p.name.startsWith(capitalize(query))))
            .toList();
    print(mylist.length);
    return query.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'Search Products ...',
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
        : mylist.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'No Products Found ...',
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
            : ListView.builder(
                itemCount: mylist.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          mylist[index].name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.blockSizeVertical * 2,
                            //fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                              text: 'from   ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: SizeConfig.blockSizeVertical * 1.2,
                                fontStyle: FontStyle.italic,
                                //fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: mylist[index].category,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.5,
                                    //fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                        ),
                        trailing: Container(
                          width: SizeConfig.safeBlockVertical * 6,
                          height: SizeConfig.safeBlockVertical * 6,
                          child: Image.network(
                            mylist[index].imageUrl,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: Loading2(),
                              );
                            },
                            fit: BoxFit.fill,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new ProductDetails(
                                    product_detail_name: mylist[index].name,
                                    product_detail_picture:
                                        mylist[index].imageUrl,
                                    product_detail_price: mylist[index].price,
                                    product_detail_category:
                                        mylist[index].category,
                                    product_detail_description:
                                        mylist[index].description,
                                    product_detail_quantity:
                                        mylist[index].quantity,
                                    product_detail_id: mylist[index].id,
                                  )));
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              );
  }
}
