import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import '../../../core/enums/product_category.dart';
import '../../listings/viewmodel/product_viewmodel.dart';

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final priceRange = ref.watch(priceRangeProvider);
    final quantityRange = ref.watch(quantityRangeProvider);
    final listingType = ref.watch(listingTypeProvider);
    final locationFilter = ref.watch(locationFilterProvider);
    final isOrganic = ref.watch(isOrganicFilterProvider);
    final hasCertificate = ref.watch(hasCertificateFilterProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Başlık ve Kapat butonu
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gelişmiş Filtreleme',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Filtreler
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Kategori seçimi
                    Text(
                      'Kategori',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Tümü'),
                          selected: selectedCategory == null,
                          onSelected: (selected) {
                            ref.read(selectedCategoryProvider.notifier).state = null;
                          },
                        ),
                        ...ProductCategory.values.map((category) {
                          final isSelected = selectedCategory == category;
                          return FilterChip(
                            label: Text(category.title),
                            selected: isSelected,
                            onSelected: (selected) {
                              ref.read(selectedCategoryProvider.notifier).state = selected ? category : null;
                            },
                          );
                        }),
                      ],
                    ),
                    const Gap(24),

                    // Fiyat aralığı
                    Text(
                      'Fiyat Aralığı',
                      style: Theme.of(context).textTheme.titleMedium,
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
                      onChanged: (values) {
                        ref.read(quantityRangeProvider.notifier).state = values;
                      },
                    ),
                    const Gap(24),

                    // İlan tipi
                    Text(
                      'İlan Tipi',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(8),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Tümü'),
                          selected: listingType == null,
                          onSelected: (selected) {
                            ref.read(listingTypeProvider.notifier).state = null;
                          },
                        ),
                        FilterChip(
                          label: const Text('Satılık'),
                          selected: listingType == 'sell',
                          onSelected: (selected) {
                            ref.read(listingTypeProvider.notifier).state = selected ? 'sell' : null;
                          },
                        ),
                        FilterChip(
                          label: const Text('Aranıyor'),
                          selected: listingType == 'buy',
                          onSelected: (selected) {
                            ref.read(listingTypeProvider.notifier).state = selected ? 'buy' : null;
                          },
                        ),
                      ],
                    ),
                    const Gap(24),

                    // Konum filtresi
                    Text(
                      'Konum',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(8),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Şehir veya ilçe ara...',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      onChanged: (value) {
                        ref.read(locationFilterProvider.notifier).state = value;
                      },
                    ),
                    const Gap(24),

                    // Diğer filtreler
                    Text(
                      'Diğer Filtreler',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(8),
                    SwitchListTile(
                      title: const Text('Organik Ürün'),
                      value: isOrganic,
                      onChanged: (value) {
                        ref.read(isOrganicFilterProvider.notifier).state = value;
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Sertifikalı Ürün'),
                      value: hasCertificate,
                      onChanged: (value) {
                        ref.read(hasCertificateFilterProvider.notifier).state = value;
                      },
                    ),
                  ],
                ),
              ),

              // Filtreleri uygula butonu
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Filtreleri Uygula'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 