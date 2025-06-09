import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/product_model.dart';
import '../../../core/enums/product_category.dart';

final marketViewModelProvider = StateNotifierProvider<MarketViewModel, AsyncValue<List<ProductModel>>>((ref) {
  return MarketViewModel(firestore: FirebaseFirestore.instance);
});

final selectedCategoryProvider = StateProvider<ProductCategory?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

class MarketViewModel extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final FirebaseFirestore firestore;

  MarketViewModel({required this.firestore}) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts({
    ProductCategory? category,
    String? searchQuery,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      Query query = firestore.collection('products')
          .orderBy('createdAt', descending: true);

      if (category != null) {
        query = query.where('category', isEqualTo: category.title);
      }

      final snapshot = await query.get();
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromJson({...data, 'id': doc.id});
      }).toList();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        products.retainWhere((product) =>
            product.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(searchQuery.toLowerCase()));
      }

      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
} 