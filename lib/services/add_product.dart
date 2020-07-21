import 'package:cafeteria/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'products';

  void uploadProduct(
      {String productName,
      String category,
      int quantity,
      double price,
      String imageUrl}) {
    var id = new Uuid();
    String productId = id.v1();

    _firestore.collection(ref).document(productId).setData({
      'id': productId,
      'name': productName,
      'category': category,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    });
  }

  Future<List<ProductModel>> getProducts() {
    _firestore.collection(ref).getDocuments().then((snap) {
      List<ProductModel> products = [];
      snap.documents
          .map((snapshot) => products.add(ProductModel.fromSnapshot(snapshot)));
      return products;
    });
  }
}
