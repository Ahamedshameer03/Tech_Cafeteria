import 'dart:ui';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/screens/authenticate/reset_password.dart';
import 'package:flutter/material.dart';

import 'authenticate/sign_in_page.dart';
import 'authenticate/sign_up_page.dart';

class MenuFrame extends StatelessWidget {
  PageController pageController = PageController();

  changePage(int page) {
    pageController.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
              child: Container(
                width: SizeConfig.safeBlockVertical * 21,
                height: SizeConfig.safeBlockVertical * 21,
                child: Image.asset(
                  'images/logo.png',
                  width: SizeConfig.safeBlockVertical * 30,
                  height: SizeConfig.safeBlockVertical * 30,
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 5,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: <Widget>[
                  SignIn(
                    gotoSignUp: () {
                      changePage(1);
                    },
                    forgotPassword: () {
                      changePage(2);
                    },
                  ),
                  SignUp(
                    gotoSignIn: () {
                      changePage(0);
                    },
                  ),
                  ResetPassword(
                    signin: () {
                      changePage(0);
                    },
                  ),
                ],
              ),
            ),
          ],
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
