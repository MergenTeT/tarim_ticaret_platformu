import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../core/enums/product_category.dart';
import '../viewmodel/market_viewmodel.dart';
import '../model/product_model.dart';

class MarketView extends HookConsumerWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(marketViewModelProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.eco,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const Gap(8),
            Text(
              'Tarım Pazarı',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: 'Ürün ara...',
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                    ref.read(marketViewModelProvider.notifier).loadProducts(
                          category: selectedCategory,
                          searchQuery: value,
                        );
                  },
                ),
              ),
              // Detailed Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        // TODO: Show filter dialog
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const FilterBottomSheet(),
                        );
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filtrele'),
                    ),
                    const Gap(8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.location_on_outlined),
                      label: const Text('Konum'),
                    ),
                    const Gap(8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sort),
                      label: const Text('Sırala'),
                    ),
                  ],
                ),
              ),
              // Category List
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: ProductCategory.values.length,
                  itemBuilder: (context, index) {
                    final category = ProductCategory.values[index];
                    final isSelected = selectedCategory == category;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(category.title),
                        onSelected: (selected) {
                          ref.read(selectedCategoryProvider.notifier).state =
                              selected ? category : null;
                          ref.read(marketViewModelProvider.notifier).loadProducts(
                                category: selected ? category : null,
                                searchQuery: searchQuery,
                              );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(marketViewModelProvider.notifier).refreshProducts(),
        child: productsState.when(
          data: (products) {
            if (products.isEmpty) {
              // Örnek ürünler oluştur
              final demoProducts = [
                ProductModel(
                  id: '1',
                  sellerId: 'seller1',
                  title: 'Organik Elma',
                  description: 'Amasya elması, taze ve organik',
                  price: 24.99,
                  category: ProductCategory.fruits.title,
                  unit: 'kg',
                  quantity: 100,
                  images: ['https://picsum.photos/200'],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  location: 'Amasya',
                ),
                ProductModel(
                  id: '2',
                  sellerId: 'seller2',
                  title: 'Taze Domates',
                  description: 'Antalya serası, sofralık domates',
                  price: 19.99,
                  category: ProductCategory.vegetables.title,
                  unit: 'kg',
                  quantity: 50,
                  images: ['https://picsum.photos/201'],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  location: 'Antalya',
                ),
                ProductModel(
                  id: '3',
                  sellerId: 'seller3',
                  title: 'Çiçek Balı',
                  description: 'Karadeniz yaylalarından doğal bal',
                  price: 450,
                  category: ProductCategory.honey.title,
                  unit: 'kg',
                  quantity: 10,
                  images: ['https://picsum.photos/202'],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  location: 'Rize',
                ),
              ];

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: demoProducts.length,
                itemBuilder: (context, index) {
                  final product = demoProducts[index];
                  return ProductCard(product: product);
                },
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Hata: $error'),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 65,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.store),
            label: 'Pazar',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            label: 'Borsa',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box),
            label: 'İlan Ekle',
          ),
          NavigationDestination(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              break; // Already in market
            case 1:
              Navigator.pushNamed(context, '/stock-market');
              break;
            case 2:
              Navigator.pushNamed(context, '/add-listing');
              break;
            case 3:
              Navigator.pushNamed(context, '/messages');
              break;
            case 4:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtrele',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          const Text('Fiyat Aralığı'),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Min',
                    suffixText: '₺',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const Gap(16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max',
                    suffixText: '₺',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const Gap(16),
          const Text('Konum'),
          const Gap(8),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Şehir seçin',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(16),
          const Text('Sıralama'),
          const Gap(8),
          SegmentedButton(
            segments: const [
              ButtonSegment(
                value: 'newest',
                label: Text('En Yeni'),
              ),
              ButtonSegment(
                value: 'price_asc',
                label: Text('Fiyat ↑'),
              ),
              ButtonSegment(
                value: 'price_desc',
                label: Text('Fiyat ↓'),
              ),
            ],
            selected: const {'newest'},
            onSelectionChanged: (values) {},
          ),
          const Gap(24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Uygula'),
          ),
        ],
      ),
    );
  }
}

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
          // TODO: Navigate to product detail
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.location ?? '',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Text(
                    '${product.price} ₺/${product.unit}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Gap(4),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 