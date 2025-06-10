import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/listings/model/product_model.dart';

final productServiceProvider = Provider((ref) => ProductService());

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Tüm ürünleri getir
  Stream<List<ProductModel>> getProducts() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .where((product) => product.isActive) // Filtrelemeyi client tarafında yapalım
          .toList();
    });
  }

  // Ürün ekle
  Future<String> addProduct(ProductModel product) async {
    final docRef = await _firestore.collection(_collection).add(product.toFirestore());
    return docRef.id;
  }

  // Ürün güncelle
  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection(_collection)
        .doc(product.id)
        .update(product.toFirestore());
  }

  // Ürün sil
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection(_collection).doc(productId).delete();
  }

  // Ürünü pasife çek
  Future<void> deactivateProduct(String productId) async {
    await _firestore
        .collection(_collection)
        .doc(productId)
        .update({'isActive': false});
  }

  // Satıcıya ait ürünleri getir
  Stream<List<ProductModel>> getSellerProducts(String sellerId) {
    return _firestore
        .collection(_collection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    });
  }

  // Kategoriye göre ürünleri getir
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .where((product) => product.isActive) // Filtrelemeyi client tarafında yapalım
          .toList();
    });
  }

  // Ürün arama
  Stream<List<ProductModel>> searchProducts(String query) {
    return _firestore
        .collection(_collection)
        .orderBy('title')
        .startAt([query.toLowerCase()])
        .endAt([query.toLowerCase() + '\uf8ff'])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .where((product) => product.isActive) // Filtrelemeyi client tarafında yapalım
          .toList();
    });
  }
} 