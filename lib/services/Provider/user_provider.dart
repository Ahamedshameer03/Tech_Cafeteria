import 'dart:async';
import 'package:cafeteria/models/orders.dart';
import 'package:cafeteria/models/users.dart';
import 'package:cafeteria/services/order_services.dart';
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
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  FirebaseUser get user => _user;

  // public variables
  List<OrderModel> orders = [];
  List<OrderModel> todayOrders = [];

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

      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      err = e.code;
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
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }

  Future<void> subCollection(String uid, List<String> prodId) async {
    await _userServices.subCollection(uid, prodId);
    notifyListeners();
  }

  Future<void> _onStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      print('null');
      _status = Status.Unauthenticated;
    } else if (firebaseUser.uid == '2G6KlfThGVe2TuNqVPVdn306F3A2') {
      _status = Status.Admin;
      //_user = firebaseUser;
      //_userModel = await _userServicse.getUserById(user.uid);
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _userModel = await _userServices.getUserById(user.uid);
    }
    notifyListeners();
  }

  Future clearCart() {
    List cart = userModel.cart;
    for (int item = 0; item < cart.length; item++) {
      Map cartItem = {
        "id": cart[item]['id'],
        "name": cart[item]['name'],
        "imageUrl": cart[item]['imageUrl'],
        "productId": cart[item]['productId'],
        "price": cart[item]['price'],
        "quantity": cart[item]['quantity'],
      };
      _userServices.removeFromCart(userId: user.uid, cartItem: cartItem);
    }
  }

  Future<bool> addToCart({
    String product_name,
    String product_imageUrl,
    String product_id,
    int product_price,
    int quantity,
  }) async {
    print("THE PRODUC IS: ${product_name}");
    print("THE qty IS: ${quantity.toString()}");

    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List cart = _userModel.cart;
      bool itemExists = false;
      Map cartItem = {
        "id": cartItemId,
        "name": product_name,
        "imageUrl": product_imageUrl,
        "productId": product_id,
        "price": product_price,
        "quantity": quantity
      };

      for (Map item in cart) {
        if (item["productId"] == cartItem["productId"]) {
//          call increment quantity
          cartItem['quantity'] += cartItem['quantity'];
          _userServices.removeFromCart(userId: _user.uid, cartItem: item);
          itemExists = true;
          break;
        }
      }

//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: cartItem);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  getOrders() async {
    orders = await _orderServices.getUserOrders(userId: _user.uid);

    notifyListeners();
  }

  Future<bool> removeFromCart({Map cartItem}) async {
    try {
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
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
