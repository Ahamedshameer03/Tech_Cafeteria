import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafeteria/screens/sign_up_page.dart';

class UserServices {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String ref = "users";

  /*createUser(String uid, Map value) {
    _database.reference().child(ref).push().set(value)
      ..catchError((err) {
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
}
