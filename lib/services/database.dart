import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection Reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUser(String name, String email, String password) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'email': email,
      'password': password,
    });
  }
}
