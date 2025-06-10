// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      category: json['category'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      location: json['location'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isSellOffer: json['isSellOffer'] as bool? ?? true,
      isOrganic: json['isOrganic'] as bool? ?? false,
      hasCertificate: json['hasCertificate'] as bool? ?? false,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'unit': instance.unit,
      'quantity': instance.quantity,
      'category': instance.category,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'location': instance.location,
      'isActive': instance.isActive,
      'isSellOffer': instance.isSellOffer,
      'isOrganic': instance.isOrganic,
      'hasCertificate': instance.hasCertificate,
      'images': instance.images,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
