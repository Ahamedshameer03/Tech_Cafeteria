import 'dart:ui';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:flutter/material.dart';

import 'authenticate/sign_in_page.dart';
import 'authenticate/sign_up_page.dart';

class MenuFrame extends StatelessWidget {
  PageController pageController = PageController();
  Duration _animationDuration = Duration(milliseconds: 500);

  void _changePage(int page) {
    pageController.animateToPage(page,
        duration: _animationDuration, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      child: Container(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'images/logo.png',
                  width: SizeConfig.safeBlockHorizontal * 30,
                  height: SizeConfig.safeBlockVertical * 30,
                ),
                Expanded(
                  child: PageView(
                    children: <Widget>[
                      SignIn(),
                      SignUp(
                        cancelBackToHome: () {
                          _changePage(0);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              //Colors.blue,
              Colors.red,
              Colors.blueAccent,
              Color.fromRGBO(255, 123, 67, 1.0),
              Colors.blueAccent,
              Color.fromRGBO(245, 50, 111, 1.0),
            ],
          ),
        ),
      ),
    );
  }
}
