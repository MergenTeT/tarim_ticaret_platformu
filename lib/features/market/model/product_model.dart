import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String sellerId,
    required String title,
    required String description,
    required double price,
    required String category,
    required String unit, // kg, ton, adet vb.
    required double quantity,
    required List<String> images,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isFeatured,
    String? location,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
} 