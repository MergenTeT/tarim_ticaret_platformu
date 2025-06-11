import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';
import '../../../core/services/temp_storage_service.dart';

class ProductService {
  final _firestore = FirebaseFirestore.instance;
  final _tempStorageService = TempStorageService();

  Stream<List<ProductModel>> getProducts() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  Stream<ProductModel> getProductById(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('Ürün bulunamadı');
      }
      final data = doc.data()!;
      return ProductModel.fromJson({
        ...data,
        'id': doc.id,
      });
    });
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').add(product.toFirestore());
    } catch (e) {
      throw Exception('Ürün eklenirken bir hata oluştu: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toFirestore());
    } catch (e) {
      throw Exception('Ürün güncellenirken bir hata oluştu: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Ürün silinirken bir hata oluştu: $e');
    }
  }
} 