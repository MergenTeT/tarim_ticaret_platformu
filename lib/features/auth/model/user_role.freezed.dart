// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserRole _$UserRoleFromJson(Map<String, dynamic> json) {
  return _UserRole.fromJson(json);
}

/// @nodoc
mixin _$UserRole {
  List<String> get roles => throw _privateConstructorUsedError;
  String get activeRole => throw _privateConstructorUsedError;
  Map<String, dynamic>? get farmerDetails => throw _privateConstructorUsedError;
  Map<String, dynamic>? get buyerDetails => throw _privateConstructorUsedError;

  /// Serializes this UserRole to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRoleCopyWith<UserRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRoleCopyWith<$Res> {
  factory $UserRoleCopyWith(UserRole value, $Res Function(UserRole) then) =
      _$UserRoleCopyWithImpl<$Res, UserRole>;
  @useResult
  $Res call({
    List<String> roles,
    String activeRole,
    Map<String, dynamic>? farmerDetails,
    Map<String, dynamic>? buyerDetails,
  });
}

/// @nodoc
class _$UserRoleCopyWithImpl<$Res, $Val extends UserRole>
    implements $UserRoleCopyWith<$Res> {
  _$UserRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roles = null,
    Object? activeRole = null,
    Object? farmerDetails = freezed,
    Object? buyerDetails = freezed,
  }) {
    return _then(
      _value.copyWith(
            roles: null == roles
                ? _value.roles
                : roles // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            activeRole: null == activeRole
                ? _value.activeRole
                : activeRole // ignore: cast_nullable_to_non_nullable
                      as String,
            farmerDetails: freezed == farmerDetails
                ? _value.farmerDetails
                : farmerDetails // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            buyerDetails: freezed == buyerDetails
                ? _value.buyerDetails
                : buyerDetails // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserRoleImplCopyWith<$Res>
    implements $UserRoleCopyWith<$Res> {
  factory _$$UserRoleImplCopyWith(
    _$UserRoleImpl value,
    $Res Function(_$UserRoleImpl) then,
  ) = __$$UserRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> roles,
    String activeRole,
    Map<String, dynamic>? farmerDetails,
    Map<String, dynamic>? buyerDetails,
  });
}

/// @nodoc
class __$$UserRoleImplCopyWithImpl<$Res>
    extends _$UserRoleCopyWithImpl<$Res, _$UserRoleImpl>
    implements _$$UserRoleImplCopyWith<$Res> {
  __$$UserRoleImplCopyWithImpl(
    _$UserRoleImpl _value,
    $Res Function(_$UserRoleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roles = null,
    Object? activeRole = null,
    Object? farmerDetails = freezed,
    Object? buyerDetails = freezed,
  }) {
    return _then(
      _$UserRoleImpl(
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        activeRole: null == activeRole
            ? _value.activeRole
            : activeRole // ignore: cast_nullable_to_non_nullable
                  as String,
        farmerDetails: freezed == farmerDetails
            ? _value._farmerDetails
            : farmerDetails // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        buyerDetails: freezed == buyerDetails
            ? _value._buyerDetails
            : buyerDetails // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRoleImpl implements _UserRole {
  const _$UserRoleImpl({
    required final List<String> roles,
    required this.activeRole,
    final Map<String, dynamic>? farmerDetails,
    final Map<String, dynamic>? buyerDetails,
  }) : _roles = roles,
       _farmerDetails = farmerDetails,
       _buyerDetails = buyerDetails;

  factory _$UserRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRoleImplFromJson(json);

  final List<String> _roles;
  @override
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final String activeRole;
  final Map<String, dynamic>? _farmerDetails;
  @override
  Map<String, dynamic>? get farmerDetails {
    final value = _farmerDetails;
    if (value == null) return null;
    if (_farmerDetails is EqualUnmodifiableMapView) return _farmerDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _buyerDetails;
  @override
  Map<String, dynamic>? get buyerDetails {
    final value = _buyerDetails;
    if (value == null) return null;
    if (_buyerDetails is EqualUnmodifiableMapView) return _buyerDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserRole(roles: $roles, activeRole: $activeRole, farmerDetails: $farmerDetails, buyerDetails: $buyerDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRoleImpl &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.activeRole, activeRole) ||
                other.activeRole == activeRole) &&
            const DeepCollectionEquality().equals(
              other._farmerDetails,
              _farmerDetails,
            ) &&
            const DeepCollectionEquality().equals(
              other._buyerDetails,
              _buyerDetails,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_roles),
    activeRole,
    const DeepCollectionEquality().hash(_farmerDetails),
    const DeepCollectionEquality().hash(_buyerDetails),
  );

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRoleImplCopyWith<_$UserRoleImpl> get copyWith =>
      __$$UserRoleImplCopyWithImpl<_$UserRoleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRoleImplToJson(this);
  }
}

abstract class _UserRole implements UserRole {
  const factory _UserRole({
    required final List<String> roles,
    required final String activeRole,
    final Map<String, dynamic>? farmerDetails,
    final Map<String, dynamic>? buyerDetails,
  }) = _$UserRoleImpl;

  factory _UserRole.fromJson(Map<String, dynamic> json) =
      _$UserRoleImpl.fromJson;

  @override
  List<String> get roles;
  @override
  String get activeRole;
  @override
  Map<String, dynamic>? get farmerDetails;
  @override
  Map<String, dynamic>? get buyerDetails;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRoleImplCopyWith<_$UserRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
