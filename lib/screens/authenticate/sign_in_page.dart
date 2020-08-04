import 'dart:ui';
import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function gotoSignUp;
  final Function forgotPassword;

  SignIn({this.gotoSignUp, this.forgotPassword});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  String email, password;
  final formKey = GlobalKey<FormState>();

  // void SignIn Here //

  bool loading = false;
  bool saveAttempted = false;
  bool _obscureText = true;
  String err = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    SizeConfig().init(context);
    return loading == true
        ? Loading()
        : SingleChildScrollView(
            child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.safeBlockVertical * 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3,
                  ),
                  TextFormField(
                    autovalidate: saveAttempted,
                    onChanged: (textValue) {
                      setState(() {
                        email = textValue;
                      });
                    },
                    validator: (emailValue) {
                      if (emailValue.isEmpty) {
                        return 'This field is mandatory';
                      }

                      String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                          "\\@" +
                          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                          "(" +
                          "\\." +
                          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                          ")+";
                      RegExp regExp = new RegExp(p);

                      if (regExp.hasMatch(emailValue)) {
                        // So, the email is valid
                        return null;
                      }

                      return 'This is not a valid email';
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: 'Enter Email',
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.blue[100],
                            fontWeight: FontWeight.w300),
                        icon: Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.3)),
                        focusColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[100],
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            //style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.safeBlockVertical * 2.5,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 1,
                  ),
                  TextFormField(
                    autovalidate: saveAttempted,
                    onChanged: (textValue) {
                      setState(() {
                        password = textValue;
                      });
                    },
                    validator: (password) {
                      if (password.isEmpty) {
                        return 'This field is mandatory';
                      }
                      return null;
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: ' Enter Password ...',
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Colors.blue[100], fontWeight: FontWeight.w300),
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.3)),
                      icon: Icon(
                        Icons.lock_outline,
                        color: Colors.white70,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          }),
                      focusColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[100],
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          //style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.safeBlockVertical * 2.5,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: () async {
                          setState(() {
                            saveAttempted = true;
                          });

                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            setState(() => loading = true);

                            dynamic result = await user.signIn(email, password);

                            if (result == false) {
                              setState(() => loading = false);

                              err = user.getError();
                              print("inside $err");
                              if (err == 'ERROR_USER_NOT_FOUND') {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                            'No User Found With This Email Please Register'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                              if (err == 'ERROR_WRONG_PASSWORD') {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text('Wrong Password'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                              //user.statusUpdate;
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.safeBlockVertical * 1,
                            horizontal: SizeConfig.safeBlockHorizontal * 25,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              SizeConfig.safeBlockVertical * 5,
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: SizeConfig.safeBlockVertical * 2.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3,
                  ),
                  Text(
                    'Agree to Terms & Conditions',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          widget.forgotPassword();
                        },
                        child: Container(
                          height: SizeConfig.safeBlockVertical * 5,
                          child: Center(
                            child: Text(
                              'Forgot Password ?  ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: SizeConfig.safeBlockVertical * 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Do not have an Account ?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: SizeConfig.safeBlockVertical * 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockVertical * 2,
                      ),
                      InkWell(
                        onTap: () {
                          widget.gotoSignUp();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.safeBlockVertical * 1.5,
                            horizontal: SizeConfig.safeBlockHorizontal * 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              SizeConfig.safeBlockVertical * 5,
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: SizeConfig.safeBlockVertical * 2.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
  }
}
