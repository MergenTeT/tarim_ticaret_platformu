import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/enums/product_category.dart';
import '../../../core/enums/user_role.dart';
import '../../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../../core/base/base_view.dart';
import '../viewmodel/product_viewmodel.dart';

class AddListingView extends HookConsumerWidget {
  const AddListingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return authState.when(
      data: (user) {
        if (user.id.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('Lütfen giriş yapın'),
            ),
          );
        }

        return BaseView(
          title: user.primaryRole == UserRole.farmer ? 'Ürün Sat' : 'Ürün Talep Et',
          child: user.primaryRole == UserRole.farmer
              ? const FarmerListingForm()
              : const BuyerListingForm(),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Hata: $error'),
        ),
      ),
    );
  }
}

class FarmerListingForm extends ConsumerStatefulWidget {
  const FarmerListingForm({super.key});

  @override
  ConsumerState<FarmerListingForm> createState() => _FarmerListingFormState();
}

class _FarmerListingFormState extends ConsumerState<FarmerListingForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedCategory;
  String? _selectedUnit;
  bool _isLoading = false;

  final _units = ['kg', 'ton', 'adet', 'demet'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ProductViewModel'i oluştur
      final productViewModel = ref.read(productViewModelProvider.notifier);

      // İlanı ekle
      await productViewModel.addProduct(
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        unit: _selectedUnit!,
        quantity: double.parse(_quantityController.text),
        category: _selectedCategory!,
        location: _locationController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ürün başarıyla eklendi'),
            backgroundColor: Colors.green,
          ),
        );

        // Form'u temizle
        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _quantityController.clear();
        _locationController.clear();
        setState(() {
          _selectedCategory = null;
          _selectedUnit = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ürün eklenirken bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ProductViewModel'in durumunu izle
    ref.listen<AsyncValue<void>>(productViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hata: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    });

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Başlık
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Ürün Adı',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen ürün adını girin';
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
              helperText: 'Ürünün özellikleri, kalitesi, üretim yöntemi vb.',
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen açıklama girin';
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
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Fiyat',
                    border: OutlineInputBorder(),
                    prefixText: '₺ ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen fiyat girin';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Geçerli bir fiyat girin';
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
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Miktar',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen miktar girin';
              }
              if (double.tryParse(value) == null) {
                return 'Geçerli bir miktar girin';
              }
              return null;
            },
          ),
          const Gap(16),
          // Konum
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Konum',
              border: OutlineInputBorder(),
              helperText: 'Ürünün bulunduğu il/ilçe',
            ),
          ),
          const Gap(24),
          // Gönder butonu
          FilledButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('İlanı Yayınla'),
          ),
        ],
      ),
    );
  }
}

class BuyerListingForm extends ConsumerStatefulWidget {
  const BuyerListingForm({super.key});

  @override
  ConsumerState<BuyerListingForm> createState() => _BuyerListingFormState();
}

class _BuyerListingFormState extends ConsumerState<BuyerListingForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedCategory;
  String? _selectedUnit;
  bool _isLoading = false;

  final _units = ['kg', 'ton', 'adet', 'demet'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ProductViewModel'i oluştur
      final productViewModel = ref.read(productViewModelProvider.notifier);

      // İlanı ekle
      await productViewModel.addProduct(
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        unit: _selectedUnit!,
        quantity: double.parse(_quantityController.text),
        category: _selectedCategory!,
        location: _locationController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Talep başarıyla eklendi'),
            backgroundColor: Colors.green,
          ),
        );

        // Form'u temizle
        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _quantityController.clear();
        _locationController.clear();
        setState(() {
          _selectedCategory = null;
          _selectedUnit = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Talep eklenirken bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ProductViewModel'in durumunu izle
    ref.listen<AsyncValue<void>>(productViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hata: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    });

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Başlık
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Ne Arıyorsunuz?',
              border: OutlineInputBorder(),
              helperText: 'Örn: Organik Elma, Sofralık Domates',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen aradığınız ürünü girin';
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
              helperText: 'Aradığınız ürünün özellikleri, kalitesi vb.',
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen açıklama girin';
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
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Teklif Ettiğiniz Fiyat',
                    border: OutlineInputBorder(),
                    prefixText: '₺ ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen fiyat girin';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Geçerli bir fiyat girin';
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
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'İhtiyaç Duyduğunuz Miktar',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen miktar girin';
              }
              if (double.tryParse(value) == null) {
                return 'Geçerli bir miktar girin';
              }
              return null;
            },
          ),
          const Gap(16),
          // Konum
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Konum',
              border: OutlineInputBorder(),
              helperText: 'Bulunduğunuz il/ilçe',
            ),
          ),
          const Gap(24),
          // Gönder butonu
          FilledButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Talebi Yayınla'),
          ),
        ],
      ),
    );
  }
} 