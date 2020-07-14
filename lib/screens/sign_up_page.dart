import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'menu_frame.dart';

class SignUp extends StatefulWidget {
  final Function cancelBackToHome;

  SignUp({this.cancelBackToHome});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password, passwordConfirm, username;
  bool saveAttempted = false;
  final formKey = GlobalKey<FormState>();

  void _createUser({String email, String pw}) {
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
  }

  bool _obscureText = true;
  bool _obscureText_1 = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: <Widget>[
              Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.0),
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
                },
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                    color: Colors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  hintText: 'Full Name',
                  icon: Icon(
                    Icons.person_outline,
                    color: Colors.white70,
                  ),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  focusColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              SizedBox(height: 20.0),
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
                    color: Colors.white,
                  )),
                  hintText: 'Enter Email',
                  icon: Icon(
                    Icons.alternate_email,
                    color: Colors.white70,
                  ),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  focusColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              SizedBox(
                height: 20.0,
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
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  hintText: 'Password',
                  icon: Icon(
                    Icons.lock_outline,
                    color: Colors.white70,
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  focusColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              SizedBox(
                height: 20.0,
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
                    color: Colors.white,
                  )),
                  hintText: 'Re-Enter Password',
                  icon: Icon(
                    Icons.lock_outline,
                    color: Colors.white70,
                  ),
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
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  focusColor: Colors.white,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              SizedBox(
                height: 30.0,
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
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 38.0,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        saveAttempted = true;
                      });
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        _createUser(email: email, pw: password);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 34.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                      ),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
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
