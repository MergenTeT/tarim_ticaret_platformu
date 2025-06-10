import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../core/enums/product_category.dart';
import '../../../features/listings/viewmodel/product_viewmodel.dart';
import '../../../features/listings/model/product_model.dart';
import '../../../core/base/base_view.dart';

class MarketView extends HookConsumerWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('MarketView: build çağrıldı');
    final productsState = ref.watch(productsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return BaseView(
      title: 'Pazar',
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
        ),
      ],
      child: Column(
        children: [
          // Kategori filtreleme
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ActionChip(
                  label: const Text('Tümü'),
                  onPressed: () => ref.read(selectedCategoryProvider.notifier).state = null,
                  backgroundColor: selectedCategory == null
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  labelStyle: TextStyle(
                    color: selectedCategory == null
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                  ),
                ),
                const Gap(8),
                ...ProductCategory.values.map((category) {
                  final isSelected = selectedCategory == category.title;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(category.title),
                      onPressed: () => ref.read(selectedCategoryProvider.notifier).state = category.title,
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          // İlan listesi
          Expanded(
            child: productsState.when(
              data: (products) {
                debugPrint('MarketView: Ürünler yüklendi. Toplam: ${products.length}');
                products.forEach((product) {
                  debugPrint('MarketView: Ürün: ${product.title} - ID: ${product.id}');
                });

                if (products.isEmpty) {
                  debugPrint('MarketView: Ürün listesi boş');
                  return const Center(
                    child: Text('Henüz ilan bulunmuyor'),
                  );
                }

                // Kategoriye göre filtrele
                final filteredProducts = selectedCategory != null
                    ? products.where((p) => p.category == selectedCategory).toList()
                    : products;

                if (filteredProducts.isEmpty) {
                  debugPrint('MarketView: Filtrelenmiş ürün listesi boş');
                  return const Center(
                    child: Text('Bu kategoride ilan bulunmuyor'),
                  );
                }

                debugPrint('MarketView: Filtrelenmiş ürün sayısı: ${filteredProducts.length}');

                return RefreshIndicator(
                  onRefresh: () async {
                    debugPrint('MarketView: Yenileme yapılıyor');
                    ref.invalidate(productsProvider);
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
                );
              },
              loading: () {
                debugPrint('MarketView: Ürünler yükleniyor');
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (error, stackTrace) {
                debugPrint('MarketView: Hata oluştu: $error');
                debugPrint('MarketView: Stack trace: $stackTrace');
                return Center(
                  child: Text('Hata: $error'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Seçili kategori için provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push('/product/${product.id}', extra: product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İlan türü etiketi
            Container(
              width: double.infinity,
              color: product.isSellOffer
                  ? Colors.green.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                product.isSellOffer ? 'SATILIK' : 'ARANIYOR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: product.isSellOffer ? Colors.green : Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  // Fiyat
                  Text(
                    '₺${product.price.toStringAsFixed(2)} / ${product.unit}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Gap(4),
                  // Miktar
                  Text(
                    'Miktar: ${product.quantity} ${product.unit}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Gap(4),
                  // Konum
                  if (product.location != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            product.location!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Gap(4),
                  // Tarih
                  Text(
                    _formatDate(product.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
} 