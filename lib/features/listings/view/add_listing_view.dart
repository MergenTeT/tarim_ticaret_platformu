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
          return BaseView(
            title: 'İlan Ekle',
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('İlan eklemek için giriş yapmalısınız'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Giriş Yap'),
                  ),
                ],
              ),
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
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _certificateFile = ValueNotifier<File?>(null);

  Future<void> _pickCertificate() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      _certificateFile.value = File(image.path);
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      if (isStartDate) {
        _startDateController.text = formattedDate;
      } else {
        _endDateController.text = formattedDate;
      }
    }
  }

  Widget _buildImagePreview() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: _pickImages,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 104,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fotoğraf Ekle',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final image = _selectedImages[index - 1];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Container(
                  width: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
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
    _startDateController.dispose();
    _endDateController.dispose();
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
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Fotoğraf Ekleme Alanı
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ürün Fotoğrafları',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'En az bir fotoğraf ekleyin',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildImagePreview(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // İlan Detayları
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İlan Detayları',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // İlan Başlığı
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'İlan Başlığı',
                      hintText: 'Örn: Taze Organik Domates',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir başlık girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Kategori
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Ürün Kategorisi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                  const SizedBox(height: 16),
                  // Fiyat ve Birim
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Birim Fiyat',
                            prefixText: '₺ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Fiyat gerekli';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Geçerli bir fiyat girin';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Birim',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                  const SizedBox(height: 16),
                  // Miktar
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Toplam Miktar',
                      suffixText: _selectedUnit,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Miktar gerekli';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Geçerli bir miktar girin';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Konum Bilgisi
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Konum Bilgisi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  CityDistrictPicker(
                    selectedCity: selectedCity.value,
                    selectedDistrict: selectedDistrict.value,
                    cities: turkiyeIlleri,
                    onCitySelected: (city) => selectedCity.value = city,
                    onDistrictSelected: (district) => selectedDistrict.value = district,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Satış Tarihi
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tahmini Satış Tarihi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startDateController,
                          readOnly: true,
                          onTap: () => _selectDate(true),
                          decoration: InputDecoration(
                            labelText: 'Başlangıç Tarihi',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Başlangıç tarihi seçin';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _endDateController,
                          readOnly: true,
                          onTap: () => _selectDate(false),
                          decoration: InputDecoration(
                            labelText: 'Bitiş Tarihi',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitiş tarihi seçin';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Ürün Özellikleri
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ürün Özellikleri',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: isOrganic,
                    builder: (context, isOrganicValue, child) {
                      return SwitchListTile(
                        title: const Text('Organik Ürün'),
                        value: isOrganicValue,
                        onChanged: (value) {
                          isOrganic.value = value;
                          if (!value) {
                            hasCertificate.value = false;
                            _certificateFile.value = null;
                          }
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isOrganic,
                    builder: (context, isOrganicValue, child) {
                      if (!isOrganicValue) return const SizedBox.shrink();
                      return ValueListenableBuilder<bool>(
                        valueListenable: hasCertificate,
                        builder: (context, hasCertificateValue, child) {
                          return Column(
                            children: [
                              SwitchListTile(
                                title: const Text('Sertifikalı'),
                                value: hasCertificateValue,
                                onChanged: (value) {
                                  hasCertificate.value = value;
                                  if (!value) {
                                    _certificateFile.value = null;
                                  }
                                },
                              ),
                              if (hasCertificateValue)
                                ValueListenableBuilder<File?>(
                                  valueListenable: _certificateFile,
                                  builder: (context, file, child) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (file != null)
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 120,
                                                  width: double.infinity,
                                                  margin: const EdgeInsets.only(bottom: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    image: DecorationImage(
                                                      image: FileImage(file),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      _certificateFile.value = null;
                                                    },
                                                    icon: const Icon(Icons.close),
                                                    style: IconButton.styleFrom(
                                                      backgroundColor: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          OutlinedButton.icon(
                                            onPressed: _pickCertificate,
                                            icon: const Icon(Icons.upload_file),
                                            label: Text(file == null
                                                ? 'Sertifika Yükle'
                                                : 'Sertifikayı Değiştir'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Açıklama
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Açıklama',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Ürününüz hakkında detaylı bilgi verin...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir açıklama girin';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Kaydet Butonu
          FilledButton.icon(
            onPressed: _isLoading ? null : _submitForm,
            icon: _isLoading
                ? Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Icon(Icons.check),
            label: Text(_isLoading ? 'Kaydediliyor...' : 'İlanı Yayınla'),
          ),
          const SizedBox(height: 32),
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
  String? _selectedCategory;
  String? _selectedUnit;
  final _units = ['kg', 'ton', 'adet', 'demet'];
  final selectedCity = ValueNotifier<String?>(null);
  final selectedDistrict = ValueNotifier<String?>(null);
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      setState(() {
        if (isStartDate) {
          _startDateController.text = formattedDate;
        } else {
          _endDateController.text = formattedDate;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final productViewModel = ref.read(productViewModelProvider.notifier);

      await productViewModel.addProduct(
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        unit: _selectedUnit!,
        quantity: double.parse(_quantityController.text),
        category: _selectedCategory!,
        location: selectedCity.value != null
            ? selectedDistrict.value != null
                ? '${selectedCity.value}, ${selectedDistrict.value}'
                : selectedCity.value
            : null,
        isOrganic: false,
        hasCertificate: false,
        images: const [],
      );

      if (mounted) {
        context.go('/market');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Talep başarıyla eklendi'),
            backgroundColor: Colors.green,
          ),
        );

        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _quantityController.clear();
        _startDateController.clear();
        _endDateController.clear();
        setState(() {
          _selectedCategory = null;
          _selectedUnit = null;
          selectedCity.value = null;
          selectedDistrict.value = null;
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
          // İlan Detayları
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İlan Detayları',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // İlan Başlığı
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Ne Arıyorsunuz?',
                      hintText: 'Örn: Organik Elma, Sofralık Domates',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen aradığınız ürünü girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Kategori
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Ürün Kategorisi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                  const SizedBox(height: 16),
                  // Fiyat ve Birim
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Teklif Ettiğiniz Fiyat',
                            prefixText: '₺ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Fiyat gerekli';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Geçerli bir fiyat girin';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Birim',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                  const SizedBox(height: 16),
                  // Miktar
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'İhtiyaç Duyduğunuz Miktar',
                      suffixText: _selectedUnit,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Miktar gerekli';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Geçerli bir miktar girin';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Konum Bilgisi
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Konum Bilgisi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  CityDistrictPicker(
                    selectedCity: selectedCity.value,
                    selectedDistrict: selectedDistrict.value,
                    cities: turkiyeIlleri,
                    onCitySelected: (city) => selectedCity.value = city,
                    onDistrictSelected: (district) => selectedDistrict.value = district,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Talep Tarihi
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Talep Tarihi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startDateController,
                          readOnly: true,
                          onTap: () => _selectDate(true),
                          decoration: InputDecoration(
                            labelText: 'Başlangıç Tarihi',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Başlangıç tarihi seçin';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _endDateController,
                          readOnly: true,
                          onTap: () => _selectDate(false),
                          decoration: InputDecoration(
                            labelText: 'Bitiş Tarihi',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitiş tarihi seçin';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Açıklama
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Açıklama',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Aradığınız ürünün özellikleri, kalitesi, özel istekleriniz...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen bir açıklama girin';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Kaydet Butonu
          FilledButton.icon(
            onPressed: _isLoading ? null : _submitForm,
            icon: _isLoading
                ? Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Icon(Icons.check),
            label: Text(_isLoading ? 'Kaydediliyor...' : 'Talebi Yayınla'),
          ),
          const SizedBox(height: 32),
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