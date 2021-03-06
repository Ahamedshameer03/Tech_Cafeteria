import 'package:cafeteria/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String collection = "users";
  String uCollection = "users/userCollection";
  Firestore _firestore = Firestore.instance;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    _firestore.collection(collection).document(id).setData(values);
  }

  void updateUserData(Map<String, dynamic> values) {
    _firestore.collection(collection).document(values['id']).updateData(values);
  }

  void subCollection(String id, List<String> prodId) {
    _firestore.collection("users").document(id).setData({
      'likes': FieldValue.arrayUnion([prodId])
    });
  }

  void addToCart({String userId, Map cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "cart": FieldValue.arrayUnion([cartItem]),
    });
  }

  Future<List<DocumentSnapshot>> getUsers() =>
      _firestore.collection(collection).getDocuments().then((snaps) {
        return snaps.documents;
      });

  void removeFromCart({String userId, Map cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore.collection(collection).document(userId).updateData({
      "cart": FieldValue.arrayRemove([cartItem])
    });
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).document(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
