// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  primaryRole: $enumDecode(_$UserRoleEnumMap, json['primaryRole']),
  secondaryRole: $enumDecodeNullable(_$UserRoleEnumMap, json['secondaryRole']),
  isOnline: json['isOnline'] as bool? ?? false,
  profileImage: json['profileImage'] as String?,
  favoriteListings:
      (json['favoriteListings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastSeen: json['lastSeen'] == null
      ? null
      : DateTime.parse(json['lastSeen'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'primaryRole': _$UserRoleEnumMap[instance.primaryRole]!,
      'secondaryRole': _$UserRoleEnumMap[instance.secondaryRole],
      'isOnline': instance.isOnline,
      'profileImage': instance.profileImage,
      'favoriteListings': instance.favoriteListings,
      'lastSeen': instance.lastSeen?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.farmer: 'farmer',
  UserRole.buyer: 'buyer',
  UserRole.farmerBuyer: 'farmerBuyer',
};
