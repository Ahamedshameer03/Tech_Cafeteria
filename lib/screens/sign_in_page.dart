import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_page.dart';

class SignIn extends StatefulWidget {
  final Function cancelBackToHome;

  SignIn({this.cancelBackToHome});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password;
  SharedPreferences preferences;
  final formKey = GlobalKey<FormState>();

  // void SignIn Here //

  void _signIn(String em, String pw) {
    _auth
        .signInWithEmailAndPassword(email: em, password: pw)
        .then((authResult) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((err) {
      print(err.code);
      if (err.code == 'ERROR_INVALID_EMAIL') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Invalid Email'),
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
      if (err.code == 'ERROR_USER_NOT_FOUND') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('No User Found With This Email Please Register'),
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
      if (err.code == 'ERROR_WRONG_PASSWORD') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Invalid Password'),
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

  bool saveAttempted = false;
  bool _obscureText = true;
  bool loading = false;
  bool isLogedin = false;

  /*@override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      loading = true;
    });

    preferences = await SharedPreferences.getInstance();
    isLogedin = await googleSignIn.isSignedIn();

    if (isLogedin) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
    setState(() {
      loading = false;
    });
  }

  Future handleSignIn() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      loading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;
    FirebaseUser firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)) as FirebaseUser;

    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if (documents.length == 0) {
        // Insert Users To Collection
        Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .setData({
          "id": firebaseUser.uid,
          "username": firebaseUser.displayName,
          "profilePicture": firebaseUser.photoUrl
        });

        await preferences.setString("id", firebaseUser.uid);
        await preferences.setString("username", firebaseUser.displayName);
        await preferences.setString("photoUrl", firebaseUser.photoUrl);
      } else {
        await preferences.setString("id", documents[0]['id']);
        await preferences.setString("username", documents[0]['username']);
        await preferences.setString("photoUrl", documents[0]['photoUrl']);
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20.0,
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
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                hintText: 'Enter Email',
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
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: Colors.redAccent,
                  onTap: () {
                    _signIn(email, password);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 100.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                    ),
                    child: Text(
                      'Sign In',
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
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Do not have an Account?',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                SizedBox(
                  width: 10.0,
                ),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back,
                          color: Colors.red,
                        ),
                        Text(
                          ' Swipe Left',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
