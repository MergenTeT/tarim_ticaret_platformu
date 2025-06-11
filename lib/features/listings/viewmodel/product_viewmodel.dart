import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/user_role.dart';
import '../../../features/auth/viewmodel/auth_viewmodel.dart';
import '../model/product_model.dart';
import '../../../core/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/enums/product_category.dart';
import '../../../features/market/view/market_view.dart';

// Arama sorgusu için provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Fiyat aralığı için provider
final priceRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(0, 10000));

// Miktar aralığı için provider
final quantityRangeProvider = StateProvider<RangeValues>((ref) => const RangeValues(0, 1000));

// İlan tipi için provider
final listingTypeProvider = StateProvider<String?>((ref) => null);

// Konum filtresi için provider
final locationFilterProvider = StateProvider<String>((ref) => '');

// Sıralama için provider
final sortByProvider = StateProvider<String>((ref) => 'date');

// Organik ürün filtresi için provider
final isOrganicFilterProvider = StateProvider<bool>((ref) => false);

// Sertifika filtresi için provider
final hasCertificateFilterProvider = StateProvider<bool>((ref) => false);

// Kategori seçimi için provider
final selectedCategoryProvider = StateProvider<ProductCategory?>((ref) => null);

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

// Filtrelenmiş ürünler için provider
final filteredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final productsAsyncValue = ref.watch(productsProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final priceRange = ref.watch(priceRangeProvider);
  final quantityRange = ref.watch(quantityRangeProvider);
  final listingType = ref.watch(listingTypeProvider);
  final locationFilter = ref.watch(locationFilterProvider).toLowerCase();
  final sortBy = ref.watch(sortByProvider);
  final isOrganic = ref.watch(isOrganicFilterProvider);
  final hasCertificate = ref.watch(hasCertificateFilterProvider);

  return productsAsyncValue.when(
    data: (products) {
      debugPrint('Toplam ürün sayısı: ${products.length}');
      debugPrint('Seçili kategori: ${selectedCategory?.toString()}');
      
      var filteredProducts = products.where((product) {
        // Debug için ürün kategorilerini yazdır
        debugPrint('Ürün kategorisi: ${product.category}');
        
        // Arama filtresi
        if (searchQuery.isNotEmpty) {
          final matchesTitle = product.title.toLowerCase().contains(searchQuery);
          final matchesDescription = product.description.toLowerCase().contains(searchQuery);
          if (!matchesTitle && !matchesDescription) return false;
        }

        // Kategori filtresi
        if (selectedCategory != null) {
          // Ürünün kategorisini küçük harfe çevir
          final productCategoryLower = product.category.toLowerCase().trim();
          // Seçili kategorinin başlığını küçük harfe çevir
          final selectedCategoryLower = selectedCategory.toString().toLowerCase().trim();
          
          debugPrint('Karşılaştırma yapılıyor:');
          debugPrint('Ürün kategorisi (lower): "$productCategoryLower"');
          debugPrint('Seçili kategori (lower): "$selectedCategoryLower"');
          
          final matches = productCategoryLower == selectedCategoryLower;
          debugPrint('Kategori eşleşmesi: $matches');
          if (!matches) return false;
        }

        // Fiyat filtresi
        if (product.price < priceRange.start || product.price > priceRange.end) return false;

        // Miktar filtresi
        if (product.quantity < quantityRange.start || product.quantity > quantityRange.end) return false;

        // İlan tipi filtresi
        if (listingType != null) {
          if (listingType == 'sell' && !product.isSellOffer) return false;
          if (listingType == 'buy' && product.isSellOffer) return false;
        }

        // Konum filtresi
        if (locationFilter.isNotEmpty && product.location != null) {
          if (!product.location!.toLowerCase().contains(locationFilter)) return false;
        }

        // Organik filtresi
        if (isOrganic && !product.isOrganic) return false;

        // Sertifika filtresi
        if (hasCertificate && !product.hasCertificate) return false;

        return true;
      }).toList();

      // Sıralama
      switch (sortBy) {
        case 'price_asc':
          filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        case 'price_desc':
          filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        case 'date':
          filteredProducts.sort((a, b) {
            final aDate = a.createdAt ?? DateTime.now();
            final bDate = b.createdAt ?? DateTime.now();
            return bDate.compareTo(aDate);
          });
      }

      debugPrint('Filtrelenmiş ürün sayısı: ${filteredProducts.length}');
      return AsyncValue.data(filteredProducts);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
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