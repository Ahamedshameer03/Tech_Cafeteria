import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/category_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  CategoryService _categoryService = CategoryService();

  bool loading = true;

  @override
  void initState() {
    loading = true;
    _getCategories();
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
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
                "Category List",
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
                itemCount: categories.length,
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
                          categories[index].data['category'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          _categoryAlert(index);
                        },
                        trailing: Image.network(
                          categories[index].data['imageUrl'],
                          height: SizeConfig.safeBlockVertical * 6,
                          width: SizeConfig.safeBlockVertical * 6,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  void _categoryAlert(int numb) {
    var alert = new AlertDialog(
      title: Text(
        'Category Details',
      ),
      content: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7)
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
        height: SizeConfig.safeBlockVertical * 20,
        child: Column(
          children: <Widget>[
            Image.network(
              categories[numb].data['imageUrl'],
              height: SizeConfig.safeBlockVertical * 15,
              width: SizeConfig.safeBlockVertical * 15,
            ),
            Text(
              categories[numb].data['category'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockVertical * 2,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alert);
  }
}
