import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  final Function signin;

  ResetPassword({this.signin});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool loading = false;
  bool saveAttempted = false;
  final formKey = GlobalKey<FormState>();
  String err = '';
  String email;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    SizeConfig().init(context);
    return loading
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
                        'Forgot Password ?',
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
                          hintText: 'Enter Email',
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Colors.blue[100],
                              fontWeight: FontWeight.w300),
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
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            saveAttempted = true;
                          });

                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();

                            dynamic result = await user.resetPassword(email);

                            if (result == true) {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text('Email Sent !'),
                                      content: Text(
                                          'Reset link sent to the given email'),
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
                            } else {
                              setState(() {
                                loading = false;
                              });

                              err = user.getError();
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
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: SizeConfig.safeBlockVertical * 2.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 6,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                widget.signin();
                              },
                              child: Container(
                                height: SizeConfig.safeBlockVertical * 5,
                                child: Center(
                                  child: Text(
                                    'Return to SignIn',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize:
                                          SizeConfig.safeBlockVertical * 2.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ],
                  ),
                )),
          );
  }
}
