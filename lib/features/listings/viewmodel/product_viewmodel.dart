import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/user_role.dart';
import '../../../features/auth/viewmodel/auth_viewmodel.dart';
import '../model/product_model.dart';
import '../../../core/services/product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) => ProductService());

final productsProvider = StreamProvider<List<ProductModel>>((ref) {
  final productService = ref.watch(productServiceProvider);
  return productService.getProducts();
});

final productsByCategoryProvider = StreamProvider.family<List<ProductModel>, String>((ref, category) {
  final productService = ref.watch(productServiceProvider);
  return productService.getProductsByCategory(category);
});

final sellerProductsProvider = StreamProvider.family<List<ProductModel>, String>((ref, sellerId) {
  final productService = ref.watch(productServiceProvider);
  return productService.getSellerProducts(sellerId);
});

final searchProductsProvider = StreamProvider.family<List<ProductModel>, String>((ref, query) {
  final productService = ref.watch(productServiceProvider);
  return productService.searchProducts(query);
});

final productViewModelProvider = StateNotifierProvider<ProductViewModel, AsyncValue<void>>((ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState.when(
    data: (user) => ProductViewModel(
      ref.watch(productServiceProvider),
      user.id,
      user.name,
      user.primaryRole,
    ),
    loading: () => throw Exception('Kullanıcı bilgileri yükleniyor'),
    error: (error, stack) => throw Exception('Kullanıcı bilgileri alınamadı: $error'),
  );
});

class ProductViewModel extends StateNotifier<AsyncValue<void>> {
  final ProductService _productService;
  final String _sellerId;
  final String _sellerName;
  final UserRole _userRole;

  ProductViewModel(
    this._productService,
    this._sellerId,
    this._sellerName,
    this._userRole,
  ) : super(const AsyncValue.data(null));

  Future<String?> addProduct({
    required String title,
    required String description,
    required double price,
    required String unit,
    required double quantity,
    required String category,
    String? location,
    bool isOrganic = false,
    bool hasCertificate = false,
    List<String> images = const [],
  }) async {
    try {
      state = const AsyncValue.loading();

      // Ürün modelini oluştur
      final product = ProductModel(
        id: '', // Firestore otomatik oluşturacak
        title: title,
        description: description,
        price: price,
        unit: unit,
        quantity: quantity,
        category: category,
        sellerId: _sellerId,
        sellerName: _sellerName,
        location: location,
        isActive: true,
        isSellOffer: _userRole == UserRole.farmer,
        isOrganic: isOrganic,
        hasCertificate: hasCertificate,
        images: images,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Firestore'a kaydet
      final productId = await _productService.addProduct(product);
      state = const AsyncValue.data(null);
      return productId;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      state = const AsyncValue.loading();
      await _productService.updateProduct(product);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      state = const AsyncValue.loading();
      await _productService.deleteProduct(productId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 