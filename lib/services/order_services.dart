import 'package:cafeteria/models/orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices {
  String collection = "orders";
  Firestore _firestore = Firestore.instance;
  OrderModel order;

  void createOrder(
      {String userId,
      String id,
      String description,
      String status,
      List cart,
      int totalPrice}) {
    _firestore.collection(collection).document(id).setData({
      "userId": userId,
      "id": id,
      "cart": cart,
      "total": totalPrice,
      "createdAt": DateTime.now(),
      "description": description,
      "status": status
    });
  }

  Future<List<OrderModel>> getUserOrders({String userId}) async => _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .orderBy("createdAt", descending: true)
          .getDocuments()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.documents) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });

  Future<List<DocumentSnapshot>> getOrders() async => _firestore
          .collection(collection)
          .orderBy("createdAt", descending: true)
          .getDocuments()
          .then((snaps) {
        return snaps.documents;
      });

  Future<List<DocumentSnapshot>> getOrderById({String orderId}) async =>
      _firestore
          .collection(collection)
          .where("id", isEqualTo: orderId)
          .getDocuments()
          .then((snaps) {
        return snaps.documents;
      });

  statusUpdate({String orderId}) async {
    _firestore
        .collection(collection)
        .document(orderId)
        .updateData({"status": "Delivered"});
  }
}
