import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';
import '../view/market_view.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceRange = ref.watch(priceRangeProvider);
    final isOrganic = ref.watch(organicFilterProvider);
    final isCertified = ref.watch(certifiedFilterProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Başlık ve Kapat Butonu
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtreler',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Filtre Seçenekleri
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Fiyat Aralığı
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
                        '${priceRange.start.toInt()} ₺',
                        '${priceRange.end.toInt()} ₺',
                      ),
                      onChanged: (values) {
                        ref.read(priceRangeProvider.notifier).state = values;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${priceRange.start.toInt()} ₺'),
                        Text('${priceRange.end.toInt()} ₺'),
                      ],
                    ),
                    const Gap(24),

                    // Organik Ürün Filtresi
                    SwitchListTile(
                      title: const Text('Organik Ürünler'),
                      subtitle: const Text('Sadece organik ürünleri göster'),
                      value: isOrganic,
                      onChanged: (value) {
                        ref.read(organicFilterProvider.notifier).state = value;
                      },
                    ),
                    const Gap(8),

                    // Sertifikalı Ürün Filtresi
                    SwitchListTile(
                      title: const Text('Sertifikalı Ürünler'),
                      subtitle: const Text('Sadece sertifikalı ürünleri göster'),
                      value: isCertified,
                      onChanged: (value) {
                        ref.read(certifiedFilterProvider.notifier).state = value;
                      },
                    ),
                  ],
                ),
              ),

              // Filtreleri Uygula ve Sıfırla Butonları
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ref.read(priceRangeProvider.notifier).state = const RangeValues(0, 10000);
                          ref.read(organicFilterProvider.notifier).state = false;
                          ref.read(certifiedFilterProvider.notifier).state = false;
                          ref.read(selectedCategoryProvider.notifier).state = null;
                        },
                        child: const Text('Sıfırla'),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Uygula'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 