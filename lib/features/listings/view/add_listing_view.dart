import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/enums/product_category.dart';

class AddListingView extends StatefulWidget {
  const AddListingView({super.key});

  @override
  State<AddListingView> createState() => _AddListingViewState();
}

class _AddListingViewState extends State<AddListingView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  String? _selectedCategory;
  String? _selectedUnit;

  final _units = ['kg', 'ton', 'adet', 'demet'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni İlan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Fotoğraf ekleme alanı
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: InkWell(
                onTap: () {
                  // TODO: Implement image picker
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                    const Gap(8),
                    Text(
                      'Fotoğraf Ekle',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            // Başlık
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'İlan Başlığı',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir başlık girin';
                }
                return null;
              },
            ),
            const Gap(16),
            // Kategori
            DropdownButtonFormField<String>(
              value: _selectedCategory,
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
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Lütfen bir kategori seçin';
                }
                return null;
              },
            ),
            const Gap(16),
            // Açıklama
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir açıklama girin';
                }
                return null;
              },
            ),
            const Gap(16),
            // Fiyat ve Birim
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Fiyat',
                      prefixText: '₺ ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fiyat girin';
                      }
                      return null;
                    },
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
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
                        _selectedUnit = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Birim seçin';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const Gap(16),
            // Miktar
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Miktar',
                suffixText: _selectedUnit,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Miktar girin';
                }
                return null;
              },
            ),
            const Gap(24),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Save listing
                }
              },
              child: const Text('İlanı Yayınla'),
            ),
          ],
        ),
      ),
    );
  }
} 