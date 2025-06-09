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
  lastSeen: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['lastSeen'],
    const TimestampConverter().fromJson,
  ),
  createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['createdAt'],
    const TimestampConverter().fromJson,
  ),
  updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['updatedAt'],
    const TimestampConverter().fromJson,
  ),
  phoneNumber: json['phoneNumber'] as String?,
  city: json['city'] as String?,
  deviceToken: json['deviceToken'] as String?,
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
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
      'lastSeen': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.lastSeen,
        const TimestampConverter().toJson,
      ),
      'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.createdAt,
        const TimestampConverter().toJson,
      ),
      'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.updatedAt,
        const TimestampConverter().toJson,
      ),
      'phoneNumber': instance.phoneNumber,
      'city': instance.city,
      'deviceToken': instance.deviceToken,
      'notificationsEnabled': instance.notificationsEnabled,
    };

const _$UserRoleEnumMap = {
  UserRole.farmer: 'farmer',
  UserRole.buyer: 'buyer',
  UserRole.farmerBuyer: 'farmerBuyer',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
