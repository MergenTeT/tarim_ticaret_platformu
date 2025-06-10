import 'package:flutter/material.dart';
import '../models/city_model.dart';

class CityDistrictPicker extends StatefulWidget {
  final String? selectedCity;
  final String? selectedDistrict;
  final Function(String) onCitySelected;
  final Function(String) onDistrictSelected;
  final List<CityModel> cities;

  const CityDistrictPicker({
    super.key,
    this.selectedCity,
    this.selectedDistrict,
    required this.onCitySelected,
    required this.onDistrictSelected,
    required this.cities,
  });

  @override
  State<CityDistrictPicker> createState() => _CityDistrictPickerState();
}

class _CityDistrictPickerState extends State<CityDistrictPicker> {
  String? _selectedCity;
  String? _selectedDistrict;
  List<String> _districts = [];

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
    _selectedDistrict = widget.selectedDistrict;
    if (_selectedCity != null) {
      _updateDistricts(_selectedCity!);
    }
  }

  void _updateDistricts(String cityName) {
    final city = widget.cities.firstWhere((city) => city.name == cityName);
    setState(() {
      _districts = city.districts;
      _selectedDistrict = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // İl Seçimi
        DropdownButtonFormField<String>(
          value: _selectedCity,
          decoration: InputDecoration(
            labelText: 'İl',
            hintText: 'İl seçin',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: widget.cities
              .map((city) => DropdownMenuItem(
                    value: city.name,
                    child: Text(city.name),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCity = value;
                _selectedDistrict = null;
              });
              _updateDistricts(value);
              widget.onCitySelected(value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen il seçin';
            }
            return null;
          },
          icon: const Icon(Icons.location_city),
          isExpanded: true,
          dropdownColor: Theme.of(context).colorScheme.surface,
        ),
        const SizedBox(height: 16),
        // İlçe Seçimi
        DropdownButtonFormField<String>(
          value: _selectedDistrict,
          decoration: InputDecoration(
            labelText: 'İlçe',
            hintText: _selectedCity == null ? 'Önce il seçin' : 'İlçe seçin',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabled: _selectedCity != null,
          ),
          items: _districts
              .map((district) => DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  ))
              .toList(),
          onChanged: _selectedCity == null
              ? null
              : (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDistrict = value;
                    });
                    widget.onDistrictSelected(value);
                  }
                },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen ilçe seçin';
            }
            return null;
          },
          icon: const Icon(Icons.location_on),
          isExpanded: true,
          dropdownColor: Theme.of(context).colorScheme.surface,
        ),
      ],
    );
  }
} 