import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required String unit,
    required double quantity,
    required String category,
    required String sellerId,
    required String sellerName,
    String? location,
    @Default(true) bool isActive,
    @Default(true) bool isSellOffer,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    print('Firestore data: $data');
    
    return ProductModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      unit: data['unit'] as String? ?? '',
      quantity: (data['quantity'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] as String? ?? '',
      sellerId: data['sellerId'] as String? ?? '',
      sellerName: data['sellerName'] as String? ?? '',
      location: data['location'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      isSellOffer: data['isSellOffer'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'unit': unit,
      'quantity': quantity,
      'category': category,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'location': location,
      'isActive': isActive,
      'isSellOffer': isSellOffer,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }
} 