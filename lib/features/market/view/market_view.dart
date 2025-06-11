import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../core/enums/product_category.dart';
import '../../../features/listings/viewmodel/product_viewmodel.dart';
import '../../../features/listings/model/product_model.dart';
import '../../../core/base/base_view.dart';
import 'filter_bottom_sheet.dart';

class MarketView extends HookConsumerWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(filteredProductsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final priceRange = ref.watch(priceRangeProvider);
    final quantityRange = ref.watch(quantityRangeProvider);
    final listingType = ref.watch(listingTypeProvider);
    final locationFilter = ref.watch(locationFilterProvider);
    final sortBy = ref.watch(sortByProvider);
    final searchController = useTextEditingController();

    // Debug için seçili kategoriyi yazdır
    useEffect(() {
      if (selectedCategory != null) {
        debugPrint('Kategori seçildi: ${selectedCategory.title}');
      } else {
        debugPrint('Kategori seçimi kaldırıldı');
      }
      return null;
    }, [selectedCategory]);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sabit başlık
          SliverAppBar(
            pinned: true,
            title: const Text('Tarımın Dijital Pazarı'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
          ),

          // Kaydırılabilir içerik
          SliverAppBar(
            expandedHeight: 240, // Yüksekliği artırdık
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: SingleChildScrollView( // SingleChildScrollView ekledik
                child: Column(
                  children: [
                    // Hoş geldiniz banner'ı
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primaryContainer,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tarımın Dijital Pazarına\nHoş Geldiniz',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Gap(8),
                          Text(
                            'Taze, organik ve yerel ürünler burada!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Arama ve Filtreleme
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Arama çubuğu
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Ürün ara...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                            onChanged: (value) {
                              ref.read(searchQueryProvider.notifier).state = value;
                            },
                          ),
                          const Gap(16),

                          // Filtreleme butonu
                          FilledButton.tonalIcon(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => const FilterBottomSheet(),
                              );
                            },
                            icon: const Icon(Icons.filter_list),
                            label: const Text('Gelişmiş Filtreleme'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Kategori filtreleme (sabit)
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryFilterDelegate(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Tümü'),
                        selected: selectedCategory == null,
                        onSelected: (selected) {
                          debugPrint('Tümü seçildi');
                          ref.read(selectedCategoryProvider.notifier).state = null;
                        },
                        showCheckmark: false,
                      ),
                      const Gap(8),
                      ...ProductCategory.values.map((category) {
                        final isSelected = selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category.title),
                            selected: isSelected,
                            onSelected: (selected) {
                              debugPrint('Kategori seçildi: ${category.title} (selected: $selected)');
                              ref.read(selectedCategoryProvider.notifier).state = selected ? category : null;
                            },
                            showCheckmark: false,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Aktif filtreler
          if (priceRange != const RangeValues(0, 10000) ||
              quantityRange != const RangeValues(0, 1000) ||
              listingType != null ||
              locationFilter.isNotEmpty ||
              sortBy != 'date')
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Aktif Filtreler:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Gap(8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (priceRange != const RangeValues(0, 10000))
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text('₺${priceRange.start.toInt()} - ₺${priceRange.end.toInt()}'),
                                  onSelected: (_) => ref.read(priceRangeProvider.notifier).state = const RangeValues(0, 10000),
                                  selected: true,
                                ),
                              ),
                            if (quantityRange != const RangeValues(0, 1000))
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text('${quantityRange.start.toInt()} - ${quantityRange.end.toInt()} birim'),
                                  onSelected: (_) => ref.read(quantityRangeProvider.notifier).state = const RangeValues(0, 1000),
                                  selected: true,
                                ),
                              ),
                            if (listingType != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(listingType == 'sell' ? 'Satılık' : 'Aranıyor'),
                                  onSelected: (_) => ref.read(listingTypeProvider.notifier).state = null,
                                  selected: true,
                                ),
                              ),
                            if (locationFilter.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(locationFilter),
                                  onSelected: (_) => ref.read(locationFilterProvider.notifier).state = '',
                                  selected: true,
                                ),
                              ),
                            if (sortBy != 'date')
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(
                                    switch (sortBy) {
                                      'price_asc' => 'Artan Fiyat',
                                      'price_desc' => 'Azalan Fiyat',
                                      _ => 'Tarihe Göre'
                                    },
                                  ),
                                  onSelected: (_) => ref.read(sortByProvider.notifier).state = 'date',
                                  selected: true,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // İlan listesi
          productsState.when(
            data: (products) {
              if (products.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const Gap(16),
                        Text(
                          'Filtrelere uygun ilan bulunamadı',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Text('Hata: $error'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Pazar',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Borsa',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'İlan Ekle',
          ),
          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            selectedIcon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              // Zaten pazar sayfasındayız
              break;
            case 1:
              context.push('/stock-market');
              break;
            case 2:
              context.push('/add-listing');
              break;
            case 3:
              context.push('/messages');
              break;
            case 4:
              context.push('/settings');
              break;
          }
        },
      ),
    );
  }
}

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceRange = ref.watch(priceRangeProvider);
    final quantityRange = ref.watch(quantityRangeProvider);
    final listingType = ref.watch(listingTypeProvider);
    final locationFilter = ref.watch(locationFilterProvider);
    final sortBy = ref.watch(sortByProvider);
    final isOrganic = ref.watch(isOrganicFilterProvider);
    final hasCertificate = ref.watch(hasCertificateFilterProvider);

    // TextEditingController'ları hook olarak tanımla
    final minPriceController = useTextEditingController(text: priceRange.start.toInt().toString());
    final maxPriceController = useTextEditingController(text: priceRange.end.toInt().toString());

    // State'leri hook olarak tanımla
    final selectedCity = useState<String?>(null);
    final selectedDistrict = useState<String?>(null);

    // TextEditingController'ları güncelle
    useEffect(() {
      minPriceController.text = priceRange.start.toInt().toString();
      maxPriceController.text = priceRange.end.toInt().toString();
      return null;
    }, [priceRange]);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // Başlık
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gelişmiş Filtreleme',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ref.read(priceRangeProvider.notifier).state = const RangeValues(0, 10000);
                      ref.read(quantityRangeProvider.notifier).state = const RangeValues(0, 1000);
                      ref.read(listingTypeProvider.notifier).state = null;
                      ref.read(locationFilterProvider.notifier).state = '';
                      ref.read(sortByProvider.notifier).state = 'date';
                      selectedCity.value = null;
                      selectedDistrict.value = null;
                      ref.read(isOrganicFilterProvider.notifier).state = false;
                      ref.read(hasCertificateFilterProvider.notifier).state = false;
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Sıfırla'),
                  ),
                ],
              ),
            ),
            // Filtre içeriği
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // İlan tipi
                  Text(
                    'İlan Tipi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  SegmentedButton<String?>(
                    segments: const [
                      ButtonSegment(
                        value: 'sell',
                        label: Text('Satılık'),
                        icon: Icon(Icons.sell),
                      ),
                      ButtonSegment(
                        value: 'buy',
                        label: Text('Aranıyor'),
                        icon: Icon(Icons.search),
                      ),
                    ],
                    selected: {listingType},
                    onSelectionChanged: (value) => ref.read(listingTypeProvider.notifier).state = value.first,
                    showSelectedIcon: false,
                  ),
                  const Gap(24),

                  // Fiyat aralığı
                  Text(
                    'Fiyat Aralığı',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Min',
                            prefixText: '₺ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            final min = double.tryParse(value) ?? 0;
                            ref.read(priceRangeProvider.notifier).state = RangeValues(
                              min,
                              priceRange.end,
                            );
                          },
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: TextField(
                          controller: maxPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Max',
                            prefixText: '₺ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            final max = double.tryParse(value) ?? 10000;
                            ref.read(priceRangeProvider.notifier).state = RangeValues(
                              priceRange.start,
                              max,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  RangeSlider(
                    values: priceRange,
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    labels: RangeLabels(
                      '₺${priceRange.start.toInt()}',
                      '₺${priceRange.end.toInt()}',
                    ),
                    onChanged: (values) {
                      ref.read(priceRangeProvider.notifier).state = values;
                      minPriceController.text = values.start.toInt().toString();
                      maxPriceController.text = values.end.toInt().toString();
                    },
                  ),
                  const Gap(24),

                  // Miktar aralığı
                  Text(
                    'Miktar Aralığı',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  RangeSlider(
                    values: quantityRange,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    labels: RangeLabels(
                      quantityRange.start.toInt().toString(),
                      quantityRange.end.toInt().toString(),
                    ),
                    onChanged: (values) => ref.read(quantityRangeProvider.notifier).state = values,
                  ),
                  const Gap(24),

                  // Konum
                  Text(
                    'Konum',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  // Şehir seçimi
                  DropdownButtonFormField<String>(
                    value: selectedCity.value,
                    decoration: InputDecoration(
                      labelText: 'Şehir',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'İstanbul', child: Text('İstanbul')),
                      DropdownMenuItem(value: 'Ankara', child: Text('Ankara')),
                      DropdownMenuItem(value: 'İzmir', child: Text('İzmir')),
                      // TODO: Tüm şehirler eklenecek
                    ],
                    onChanged: (value) {
                      selectedCity.value = value;
                      selectedDistrict.value = null;
                      ref.read(locationFilterProvider.notifier).state = value ?? '';
                    },
                  ),
                  const Gap(16),
                  // İlçe seçimi
                  if (selectedCity.value != null)
                    DropdownButtonFormField<String>(
                      value: selectedDistrict.value,
                      decoration: InputDecoration(
                        labelText: 'İlçe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Kadıköy', child: Text('Kadıköy')),
                        DropdownMenuItem(value: 'Beşiktaş', child: Text('Beşiktaş')),
                        DropdownMenuItem(value: 'Üsküdar', child: Text('Üsküdar')),
                        // TODO: Seçili şehre göre ilçeler eklenecek
                      ],
                      onChanged: (value) {
                        selectedDistrict.value = value;
                        ref.read(locationFilterProvider.notifier).state = value != null
                            ? '${selectedCity.value}, $value'
                            : selectedCity.value ?? '';
                      },
                    ),
                  const Gap(24),

                  // Organik ve Sertifika
                  Text(
                    'Özellikler',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  SwitchListTile(
                    title: const Text('Organik Ürün'),
                    value: isOrganic,
                    onChanged: (value) => ref.read(isOrganicFilterProvider.notifier).state = value,
                  ),
                  SwitchListTile(
                    title: const Text('Sertifikalı Ürün'),
                    value: hasCertificate,
                    onChanged: (value) => ref.read(hasCertificateFilterProvider.notifier).state = value,
                  ),
                  const Gap(24),

                  // Sıralama
                  Text(
                    'Sıralama',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'date',
                        label: Text('En Yeni'),
                        icon: Icon(Icons.schedule),
                      ),
                      ButtonSegment(
                        value: 'price_asc',
                        label: Text('Artan Fiyat'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                      ButtonSegment(
                        value: 'price_desc',
                        label: Text('Azalan Fiyat'),
                        icon: Icon(Icons.arrow_downward),
                      ),
                    ],
                    selected: {sortBy},
                    onSelectionChanged: (value) => ref.read(sortByProvider.notifier).state = value.first,
                    showSelectedIcon: false,
                  ),
                ],
              ),
            ),
            // Uygula butonu
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
                label: const Text('Filtreleri Uygula'),
              ),
            ),
          ],
        ),
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

// Kategori filtresi için özel delegate
class _CategoryFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _CategoryFilterDelegate({
    required this.child,
    this.height = 64,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _CategoryFilterDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
} 