import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function cancelBackToHome;

  SignUp({this.cancelBackToHome});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email, password, passwordConfirm, username;
  bool saveAttempted = false;
  final formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _obscureText_1 = true;
  bool loading = false;
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
                  horizontal: SizeConfig.safeBlockVertical * 5,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Sign Up',
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
                      onChanged: (textValue) {
                        setState(() {
                          username = textValue;
                        });
                      },
                      validator: (usernameValue) {
                        if (usernameValue.isEmpty) {
                          return 'This field is mandatory';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.transparent,
                        )),
                        hintText: 'Enter Name',
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.white),
                        icon: Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.3)),
                        focusColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
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
                      keyboardType: TextInputType.emailAddress,
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
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.transparent,
                        )),
                        hintText: 'Enter Email',
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.alternate_email,
                          color: Colors.white70,
                        ),
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.3)),
                        focusColor: Colors.black,
                      ),
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
                      validator: (pwValue) {
                        if (pwValue.isEmpty) {
                          return 'This field is mandatory';
                        }
                        if (pwValue.length < 8) {
                          return 'Password must be at least 8 characters';
                        }

                        return null;
                      },
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        hintText: 'Enter Password',
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
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
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.3)),
                        focusColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
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
                          passwordConfirm = textValue;
                        });
                      },
                      validator: (pwConfValue) {
                        if (pwConfValue != password) {
                          return 'Passwords must match';
                        }

                        return null;
                      },
                      obscureText: _obscureText_1,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.transparent,
                        )),
                        hintText: 'Re-Enter Password',
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.white),
                        icon: Icon(
                          Icons.lock_outline,
                          color: Colors.white70,
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText_1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText_1 = !_obscureText_1;
                              });
                            }),
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.3)),
                        focusColor: Colors.white,
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
                          onTap: () {
                            widget.cancelBackToHome();
                          },
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.safeBlockVertical * 2.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.safeBlockVertical * 3,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              saveAttempted = true;
                            });

                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              setState(() {
                                loading = true;
                              });

                              dynamic result =
                                  await user.signUp(username, email, password);

                              if (result == false) {
                                setState(() {
                                  loading = false;
                                });

                                err = user.getError();
                                if (err == 'ERROR_EMAIL_ALREADY_IN_USE') {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                            'This email already has an account associated with it'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.safeBlockVertical * 1,
                              horizontal: SizeConfig.safeBlockHorizontal * 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                30.0,
                              ),
                            ),
                            child: Text(
                              'Sign Up !',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: SizeConfig.safeBlockVertical * 2.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Agree to Terms & Conditions',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

/*Firestore.instance
                    .collection("users")
                    .document(authResult.user.uid)
                    .setData({*/

/*  void _createUser({String email, String pw}) {
    _auth
        .createUserWithEmailAndPassword(email: email, password: pw)
        .then((authResult) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MenuFrame()));
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Please Login to Continue'),
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
    }).catchError((err) {
      print(err.code);
      if (err.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                    'This email already has an account associated with it'),
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
    });
  }*/
