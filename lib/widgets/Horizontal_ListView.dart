import 'package:cafeteria/components/size_cofig.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'images/Categories/Snacks.png',
            image_caption: 'Snacks',
          ),
          Category(
            image_location: 'images/Categories/Breakfast.png',
            image_caption: 'Tiffen',
          ),
          Category(
            image_location: 'images/Categories/Drinks.png',
            image_caption: 'Drinks',
          ),
          Category(
            image_location: 'images/Categories/Lunch.png',
            image_caption: 'Lunch',
          ),
          Category(
            image_location: 'images/Categories/Fresh_Juice.png',
            image_caption: 'Fresh Juice',
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;

  Category({this.image_location, this.image_caption});

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
              title: Image.asset(
                image_location,
                width: 150.0,
                height: 120.0,
              ),
              subtitle: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  image_caption,
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
