import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/home_page.dart';
import 'package:cafeteria/services/category_service.dart';
import 'package:cafeteria/services/product_services.dart';
import 'package:cafeteria/widgets/single_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  final int categoryIndex;

  CategoryList({this.categoryIndex});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  CategoryService _categoryService = CategoryService();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  String _currentCategory;
  bool loading = false;

  void initState() {
    setState(() {
      loading = true;
    });

    _getCategories();
    //_getProducts(categ: _currentCategory);
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['category']),
              value: categories[i].data['category'],
            ));
      });
    }
    return items;
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();

      _currentCategory = categories[widget.categoryIndex].data['category'];
    });
    _getProducts(categ: _currentCategory);
  }

  ProductServices _productServices = ProductServices();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];

  _getProducts({String categ}) async {
    List<DocumentSnapshot> data =
        await _productServices.getProductsByCategory(categ);

    setState(() {
      products = data;
      loading = false;
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
      _getProducts(categ: _currentCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                      child: Icon(Icons.home)),
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
                ),
                preferredSize: Size.fromHeight(
                  SizeConfig.safeBlockVertical * 6.5,
                )),
            body: Container(
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                //addAutomaticKeepAlives: false,
                children: <Widget>[
                  Container(
                    height: SizeConfig.safeBlockVertical * 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          'Select Category     ',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        new DropdownButton(
                          //dropdownColor: Color.fromRGBO(245, 50, 111, 1.0),
                          icon: Icon(
                            Icons.sort,
                            color: Colors.red.withOpacity(0.7),
                          ),

                          elevation: 3,
                          items: categoriesDropDown,
                          onChanged: changeSelectedCategory,
                          value: _currentCategory,
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: products.length % 2 == 1
                        ? SizeConfig.safeBlockVertical *
                            24.7 *
                            ((products.length + 1) / 2)
                        : SizeConfig.safeBlockVertical *
                            24.7 *
                            (products.length / 2),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Single_Prod(
                            product_name: products[index].data['name'],
                            product_picture: products[index].data['imageUrl'],
                            product_price: products[index].data['price'],
                            product_category: products[index].data['category'],
                            product_description:
                                products[index].data['description'],
                            product_quantity: products[index].data['quantity'],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
