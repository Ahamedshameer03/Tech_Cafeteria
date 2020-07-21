import 'package:cafeteria/main.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> opacity;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      navigationPage();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void navigationPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ScreensController()));
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Theme(
        data: new ThemeData(
          canvasColor: Colors.transparent,
        ),
        child: new Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/Background.png'),
                  fit: BoxFit.cover)),
          child: Container(
            //decoration: BoxDecoration(color: transparentYellow),
            child: SafeArea(
              child: new Scaffold(
                body: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: 'Developed By '),
                              TextSpan(
                                  text: 'Shameer',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
