import 'package:cafeteria/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Product {
  String id;
  String name;
  String imageUrl;
  String description;
  int quantity;
  double price;
  String category;

  Product({
    this.id,
    this.name,
    this.category,
    this.description,
    this.imageUrl,
    this.price,
    this.quantity,
  });

  // String get id => _id;
  // String get name => _name;

  // Product.fromSnapshot(DocumentSnapshot snapshot) {
  //   _id = snapshot.data['id'];
  //   _name = snapshot.data['name'];
  // }
}

class ProductServices {
  String collection = "products";
  Firestore _firestore = Firestore.instance;

  void uploadProduct(
      {String productName,
      String category,
      int quantity,
      double price,
      String imageUrl,
      String description,
      bool featured}) {
    var id = new Uuid();
    String productId = id.v1();

    _firestore.collection(collection).document(productId).setData({
      'id': productId,
      'name': productName,
      'category': category,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'featured': featured,
      'description': description,
    });
  }

  void quantityUpdate(int quantity, String productId) {
    _firestore.collection(collection).document(productId).updateData({
      'quantity': quantity,
    });
  }

  void deleteProduct(String productId) {
    _firestore.collection(collection).document(productId).delete();
  }

  void featureUpdate(bool feature, String productId) {
    _firestore.collection(collection).document(productId).updateData({
      'featured': feature,
    });
  }

  Future<List<ProductModel>> getProducts() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  Future<List<DocumentSnapshot>> getProductsList() async =>
      _firestore.collection(collection).getDocuments().then((snaps) {
        return snaps.documents;
      });

  Future<List<DocumentSnapshot>> getProductsByCategory(String categ) async =>
      _firestore
          .collection(collection)
          .where('category', isEqualTo: categ)
          .getDocuments()
          .then((snaps) {
        return snaps.documents;
      });

  Future<List<DocumentSnapshot>> getFeaturedProducts({
    bool str = true,
  }) async =>
      _firestore
          .collection(collection)
          .where('featured', isEqualTo: str)
          .getDocuments()
          .then((snaps) {
        return snaps.documents;
      });

  Future<List<ProductModel>> getProductsOfCategory({String category}) async {
    _firestore
        .collection(collection)
        .where("category", isEqualTo: category)
        .getDocuments()
        .then((result) {
      List<ProductModel> products = [];
      for (DocumentSnapshot product in result.documents) {
        products.add(ProductModel.fromSnapshot(product));
      }
      return products;
    });
    return null;
  }

  Future<List<ProductModel>> searchProducts({String productName}) {
    // code to convert the first character to uppercase
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
          List<ProductModel> products = [];
          for (DocumentSnapshot product in result.documents) {
            products.add(ProductModel.fromSnapshot(product));
          }
          return products;
        });
  }
}
