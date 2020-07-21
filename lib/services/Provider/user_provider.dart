import 'dart:async';
import 'package:cafeteria/models/users.dart';
import 'package:cafeteria/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

enum Status {
  Admin,
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Firestore _firestore = Firestore.instance;
  UserServices _userServicse = UserServices();
  //OrderServices _orderServices = OrderServices();
  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  FirebaseUser get user => _user;

  // public variables
  //List<OrderModel> orders = [];

  final formkey = GlobalKey<FormState>();

  String err = '';

  // Named Constructor
  UserProvider.initialize() {
    _auth = FirebaseAuth.instance;

    {
      _auth.onAuthStateChanged.listen(_onStateChanged);
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      //_status = Status.Authenticating;
      //notifyListeners();
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      err = e.code;
      //_status = Status.Unauthenticated;
      //notifyListeners();
      print(e.code.toString());
      return false;
    }
  }

  void statusUpdate() {
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      //_status = Status.Authenticating;
      //notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        _firestore.collection('users').document(result.user.uid).setData({
          'name': name,
          'email': email,
          'password': password,
          'userId': result.user.uid,
        });
      });
      return true;
    } catch (e) {
      err = e.code;
      //_status = Status.Unauthenticated;
      //notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _status = Status.Authenticating;
    notifyListeners();
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  // void clearController() {
  //   name.text = "";
  //   password.text = "";
  //   email.text = "";
  // }

  Future<void> reloadUserModel() async {
    _userModel = await _userServicse.getUserById(user.uid);
    notifyListeners();
  }

  Future<void> _onStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else if (firebaseUser.uid == '2G6KlfThGVe2TuNqVPVdn306F3A2') {
      _status = Status.Admin;
      //_user = firebaseUser;
      //_userModel = await _userServicse.getUserById(user.uid);
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _userModel = await _userServicse.getUserById(user.uid);
    }
    notifyListeners();
  }

//   Future<bool> addToCard({ProductModel product, int quantity})async{
//     print("THE PRODUC IS: ${product.toString()}");
//     print("THE qty IS: ${quantity.toString()}");

//     try{
//       var uuid = Uuid();
//       String cartItemId = uuid.v4();
//       List cart = _userModel.cart;
// //      bool itemExists = false;
//       Map cartItem ={
//         "id": cartItemId,
//         "name": product.name,
//         "image": product.image,
//         "productId": product.id,
//         "price": product.price,
//         "quantity": quantity
//       };

// //      for(Map item in cart){
// //        if(item["productId"] == cartItem["productId"]){
// ////          call increment quantity
// //          itemExists = true;
// //          break;
// //        }
// //      }

// //      if(!itemExists){
//         print("CART ITEMS ARE: ${cart.toString()}");
//         _userServicse.addToCart(userId: _user.uid, cartItem: cartItem);
// //      }

//       return true;
//     }catch(e){
//       print("THE ERROR ${e.toString()}");
//       return false;
//     }

//   }

  // getOrders()async{
  //   orders = await _orderServices.getUserOrders(userId: _user.uid);
  //   notifyListeners();
  // }

  Future<bool> removeFromCart({Map cartItem}) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
      _userServicse.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      err = e.code;
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  String getError() {
    return err;
  }
}
