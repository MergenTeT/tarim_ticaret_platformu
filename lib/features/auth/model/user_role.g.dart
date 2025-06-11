// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRoleImpl _$$UserRoleImplFromJson(Map<String, dynamic> json) =>
    _$UserRoleImpl(
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      activeRole: json['activeRole'] as String,
      farmerDetails: json['farmerDetails'] as Map<String, dynamic>?,
      buyerDetails: json['buyerDetails'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserRoleImplToJson(_$UserRoleImpl instance) =>
    <String, dynamic>{
      'roles': instance.roles,
      'activeRole': instance.activeRole,
      'farmerDetails': instance.farmerDetails,
      'buyerDetails': instance.buyerDetails,
    };
