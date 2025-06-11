// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRoleDetailsImpl _$$UserRoleDetailsImplFromJson(
  Map<String, dynamic> json,
) => _$UserRoleDetailsImpl(
  roles: (json['roles'] as List<dynamic>)
      .map((e) => $enumDecode(_$UserRoleEnumMap, e))
      .toList(),
  activeRole: $enumDecode(_$UserRoleEnumMap, json['activeRole']),
  farmerDetails: json['farmerDetails'] == null
      ? null
      : FarmerDetails.fromJson(json['farmerDetails'] as Map<String, dynamic>),
  buyerDetails: json['buyerDetails'] == null
      ? null
      : BuyerDetails.fromJson(json['buyerDetails'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UserRoleDetailsImplToJson(
  _$UserRoleDetailsImpl instance,
) => <String, dynamic>{
  'roles': instance.roles.map((e) => _$UserRoleEnumMap[e]!).toList(),
  'activeRole': _$UserRoleEnumMap[instance.activeRole]!,
  'farmerDetails': instance.farmerDetails,
  'buyerDetails': instance.buyerDetails,
};

const _$UserRoleEnumMap = {
  UserRole.farmer: 'farmer',
  UserRole.buyer: 'buyer',
  UserRole.farmerBuyer: 'farmerBuyer',
};

_$FarmerDetailsImpl _$$FarmerDetailsImplFromJson(Map<String, dynamic> json) =>
    _$FarmerDetailsImpl(
      productTypes: (json['productTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      farmArea: (json['farmArea'] as num).toDouble(),
      farmLocation: json['farmLocation'] as String?,
      certificateUrl: json['certificateUrl'] as String?,
    );

Map<String, dynamic> _$$FarmerDetailsImplToJson(_$FarmerDetailsImpl instance) =>
    <String, dynamic>{
      'productTypes': instance.productTypes,
      'farmArea': instance.farmArea,
      'farmLocation': instance.farmLocation,
      'certificateUrl': instance.certificateUrl,
    };

_$BuyerDetailsImpl _$$BuyerDetailsImplFromJson(Map<String, dynamic> json) =>
    _$BuyerDetailsImpl(
      interestedCategories: (json['interestedCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      companyName: json['companyName'] as String?,
      taxNumber: json['taxNumber'] as String?,
      businessLocation: json['businessLocation'] as String?,
    );

Map<String, dynamic> _$$BuyerDetailsImplToJson(_$BuyerDetailsImpl instance) =>
    <String, dynamic>{
      'interestedCategories': instance.interestedCategories,
      'companyName': instance.companyName,
      'taxNumber': instance.taxNumber,
      'businessLocation': instance.businessLocation,
    };
