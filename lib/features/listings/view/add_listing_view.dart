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
import '../../../core/services/local_storage_service.dart';
import '../../../core/providers/local_storage_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/city_district_picker.dart';
import '../../../core/models/city_model.dart';
import '../../../core/constants/cities.dart';

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
  String? _selectedCategory;
  String? _selectedUnit;
  String? _selectedCity;
  String? _selectedDistrict;
  bool _isLoading = false;
  final _units = ['kg', 'ton', 'adet', 'demet'];
  final selectedCity = ValueNotifier<String?>(null);
  final selectedDistrict = ValueNotifier<String?>(null);
  final isOrganic = ValueNotifier<bool>(false);
  final hasCertificate = ValueNotifier<bool>(false);
  final List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      });
    }
  }

  Widget _buildImagePreview() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: _pickImages,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 32),
                      SizedBox(height: 4),
                      Text('Fotoğraf Ekle'),
                    ],
                  ),
                ),
              ),
            );
          }

          final image = _selectedImages[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedImages.removeAt(index - 1);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Önce görselleri local storage'a kaydet
      final localStorageService = ref.read(localStorageProvider);
      List<String> imagePaths = [];
      
      if (_selectedImages.isNotEmpty) {
        imagePaths = await localStorageService.saveMultipleImages(_selectedImages);
      }

      // ProductViewModel'i oluştur
      final productViewModel = ref.read(productViewModelProvider.notifier);

      // İlanı ekle
      final productId = await productViewModel.addProduct(
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        unit: _selectedUnit!,
        quantity: double.parse(_quantityController.text),
        category: _selectedCategory!,
        location: _selectedCity != null
            ? _selectedDistrict != null
                ? '$_selectedCity, $_selectedDistrict'
                : _selectedCity
            : null,
        isOrganic: isOrganic.value,
        hasCertificate: hasCertificate.value,
        images: imagePaths,
      );

      if (!mounted) return;

      // İlan başarıyla eklendiyse
      if (productId != null) {
        if (mounted) {
          context.go('/market');
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('İlan başarıyla eklendi'),
              backgroundColor: Colors.green,
            ),
          );

          // Form verilerini temizle
          _formKey.currentState?.reset();
          _titleController.clear();
          _descriptionController.clear();
          _priceController.clear();
          _quantityController.clear();
          setState(() {
            _selectedCategory = null;
            _selectedUnit = null;
            _selectedImages.clear();
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Görsel Seçici
              _buildImagePreview(),
              const Gap(16),
              // Başlık
              TextFormField(
                controller: _titleController,
                enabled: !_isLoading,
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
              CityDistrictPicker(
                cities: turkiyeIlleri, // TODO: Gerçek veriyi ekle
                onCitySelected: (city) {
                  setState(() {
                    _selectedCity = city;
                  });
                },
                onDistrictSelected: (district) {
                  setState(() {
                    _selectedDistrict = district;
                  });
                },
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
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
  String? _selectedCity;
  String? _selectedDistrict;
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
        location: _selectedCity != null
            ? _selectedDistrict != null
                ? '$_selectedCity, $_selectedDistrict'
                : _selectedCity
            : null,
      );

      if (mounted) {
        context.go('/market');
      }

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
          _selectedCity = null;
          _selectedDistrict = null;
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
          CityDistrictPicker(
            cities: turkiyeIlleri,
            onCitySelected: (city) {
              setState(() {
                _selectedCity = city;
              });
            },
            onDistrictSelected: (district) {
              setState(() {
                _selectedDistrict = district;
              });
            },
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

class _AddImageButton extends StatelessWidget {
  final Function(File) onImageSelected;

  const _AddImageButton({
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          onImageSelected(File(pickedFile.path));
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: Theme.of(context).colorScheme.outline,
            ),
            const Gap(4),
            Text(
              'Görsel Ekle',
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 