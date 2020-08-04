import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/category_list.dart';
import 'package:cafeteria/services/category_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatefulWidget {
  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];

  CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    _getCategories();
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Category(
              image_location: categories[index].data['imageUrl'],
              image_caption: categories[index].data['category'],
              categoryIndex: index,
            ),
          );
        },
      ),
    );
  }
}

class Category extends StatefulWidget {
  final String image_location;
  final String image_caption;
  final int categoryIndex;

  Category({this.image_location, this.image_caption, this.categoryIndex});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 35,
          child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryList(
                      categoryIndex: widget.categoryIndex,
                    ),
                  ),
                );
              },
              title: Image.network(
                widget.image_location,
                width: 150.0,
                height: 120.0,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Loading2(),
                  );
                },
              ),
              subtitle: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.image_caption,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 1.5,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
