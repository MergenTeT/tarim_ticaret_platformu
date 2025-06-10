import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/enums/product_category.dart';
import '../../../core/widgets/city_district_picker.dart';
import '../../../core/models/city_model.dart';

class FilterSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;
  final Map<String, dynamic>? currentFilters;
  final List<CityModel> cities;

  const FilterSheet({
    super.key,
    required this.onApplyFilters,
    this.currentFilters,
    required this.cities,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final _formKey = GlobalKey<FormState>();
  
  String? selectedCategory;
  String? selectedCity;
  String? selectedDistrict;
  RangeValues? priceRange;
  bool? isOrganic;
  bool? hasCertificate;
  String? selectedUnit;
  bool onlyActiveSales = true;

  final _units = ['kg', 'ton', 'adet', 'demet'];

  @override
  void initState() {
    super.initState();
    // Mevcut filtreleri yükle
    if (widget.currentFilters != null) {
      selectedCategory = widget.currentFilters!['category'];
      selectedCity = widget.currentFilters!['city'];
      selectedDistrict = widget.currentFilters!['district'];
      priceRange = widget.currentFilters!['priceRange'];
      isOrganic = widget.currentFilters!['isOrganic'];
      hasCertificate = widget.currentFilters!['hasCertificate'];
      selectedUnit = widget.currentFilters!['unit'];
      onlyActiveSales = widget.currentFilters!['onlyActiveSales'] ?? true;
    }
  }

  void _applyFilters() {
    if (_formKey.currentState!.validate()) {
      final filters = {
        'category': selectedCategory,
        'city': selectedCity,
        'district': selectedDistrict,
        'priceRange': priceRange,
        'isOrganic': isOrganic,
        'hasCertificate': hasCertificate,
        'unit': selectedUnit,
        'onlyActiveSales': onlyActiveSales,
      };

      widget.onApplyFilters(filters);
      Navigator.pop(context);
    }
  }

  void _resetFilters() {
    setState(() {
      selectedCategory = null;
      selectedCity = null;
      selectedDistrict = null;
      priceRange = null;
      isOrganic = null;
      hasCertificate = null;
      selectedUnit = null;
      onlyActiveSales = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  // Kategori Seçimi
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: ProductCategory.values
                        .map((category) => DropdownMenuItem(
                              value: category.title,
                              child: Text(category.title),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const Gap(16),

                  // İl ve İlçe Seçimi
                  CityDistrictPicker(
                    selectedCity: selectedCity,
                    selectedDistrict: selectedDistrict,
                    cities: widget.cities,
                    onCitySelected: (city) {
                      setState(() {
                        selectedCity = city;
                        selectedDistrict = null;
                      });
                    },
                    onDistrictSelected: (district) {
                      setState(() {
                        selectedDistrict = district;
                      });
                    },
                  ),
                  const Gap(16),

                  // Birim Seçimi
                  DropdownButtonFormField<String>(
                    value: selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Birim',
                      border: OutlineInputBorder(),
                    ),
                    items: _units
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUnit = value;
                      });
                    },
                  ),
                  const Gap(16),

                  // Fiyat Aralığı
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fiyat Aralığı',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      RangeSlider(
                        values: priceRange ?? const RangeValues(0, 1000),
                        min: 0,
                        max: 1000,
                        divisions: 100,
                        labels: RangeLabels(
                          '₺${(priceRange?.start ?? 0).toStringAsFixed(0)}',
                          '₺${(priceRange?.end ?? 1000).toStringAsFixed(0)}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            priceRange = values;
                          });
                        },
                      ),
                    ],
                  ),
                  const Gap(16),

                  // Organik ve Sertifika Seçenekleri
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Organik'),
                          value: isOrganic ?? false,
                          onChanged: (value) {
                            setState(() {
                              isOrganic = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Sertifikalı'),
                          value: hasCertificate ?? false,
                          onChanged: (value) {
                            setState(() {
                              hasCertificate = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),

                  // Sadece Aktif İlanlar
                  SwitchListTile(
                    title: const Text('Sadece Aktif İlanlar'),
                    value: onlyActiveSales,
                    onChanged: (value) {
                      setState(() {
                        onlyActiveSales = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('Filtreleri Temizle'),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: FilledButton(
                    onPressed: _applyFilters,
                    child: const Text('Uygula'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 