import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Ürün ekleme
  Future<String> addProduct(ProductModel product) async {
    try {
      final docRef = await _firestore.collection(_collection).add(product.toFirestore());
      print('Ürün eklendi: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Ürün eklenirken hata: $e');
      throw Exception('Ürün eklenirken bir hata oluştu: $e');
    }
  }

  // Ürün güncelleme
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(product.id)
          .update(product.toFirestore());
    } catch (e) {
      throw Exception('Ürün güncellenirken bir hata oluştu: $e');
    }
  }

  // Ürün silme
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(_collection).doc(productId).delete();
    } catch (e) {
      throw Exception('Ürün silinirken bir hata oluştu: $e');
    }
  }

  // Tüm ürünleri getirme
  Stream<List<ProductModel>> getAllProducts() {
    print('getAllProducts çağrıldı');
    try {
      return _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            print('Firestore snapshot alındı: ${snapshot.docs.length} adet döküman var');
            return snapshot.docs.map((doc) {
              try {
                final product = ProductModel.fromFirestore(doc);
                print('Ürün dönüştürüldü: ${product.title}');
                return product;
              } catch (e) {
                print('Ürün dönüştürme hatası: $e');
                rethrow;
              }
            }).toList();
          });
    } catch (e) {
      print('getAllProducts hatası: $e');
      rethrow;
    }
  }

  // Kategori bazlı ürünleri getirme
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  // Satıcıya ait ürünleri getirme
  Stream<List<ProductModel>> getSellerProducts(String sellerId) {
    return _firestore
        .collection(_collection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  // Ürün detayı getirme
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Ürün getirilirken bir hata oluştu: $e');
    }
  }

  // Ürün arama
  Stream<List<ProductModel>> searchProducts(String query) {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('title')
        .startAt([query])
        .endAt([query + '\uf8ff'])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }
} 