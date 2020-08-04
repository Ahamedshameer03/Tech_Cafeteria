import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  Firestore _firestore = Firestore.instance;
  String ref = 'categories';

  void createCategory(String name, String imageUrl) {
    var id = new Uuid();
    String categoryId = id.v1();

    _firestore.collection(ref).document(categoryId).setData({
      'category': name,
      'imageUrl': imageUrl,
    });
  }

  Future<List<DocumentSnapshot>> getCategories() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });
}
