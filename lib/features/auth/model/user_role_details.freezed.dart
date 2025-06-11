// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserRoleDetails _$UserRoleDetailsFromJson(Map<String, dynamic> json) {
  return _UserRoleDetails.fromJson(json);
}

/// @nodoc
mixin _$UserRoleDetails {
  List<UserRole> get roles => throw _privateConstructorUsedError;
  UserRole get activeRole => throw _privateConstructorUsedError;
  FarmerDetails? get farmerDetails => throw _privateConstructorUsedError;
  BuyerDetails? get buyerDetails => throw _privateConstructorUsedError;

  /// Serializes this UserRoleDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRoleDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRoleDetailsCopyWith<UserRoleDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRoleDetailsCopyWith<$Res> {
  factory $UserRoleDetailsCopyWith(
    UserRoleDetails value,
    $Res Function(UserRoleDetails) then,
  ) = _$UserRoleDetailsCopyWithImpl<$Res, UserRoleDetails>;
  @useResult
  $Res call({
    List<UserRole> roles,
    UserRole activeRole,
    FarmerDetails? farmerDetails,
    BuyerDetails? buyerDetails,
  });

  $FarmerDetailsCopyWith<$Res>? get farmerDetails;
  $BuyerDetailsCopyWith<$Res>? get buyerDetails;
}

/// @nodoc
class _$UserRoleDetailsCopyWithImpl<$Res, $Val extends UserRoleDetails>
    implements $UserRoleDetailsCopyWith<$Res> {
  _$UserRoleDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRoleDetails
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
                      as List<UserRole>,
            activeRole: null == activeRole
                ? _value.activeRole
                : activeRole // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            farmerDetails: freezed == farmerDetails
                ? _value.farmerDetails
                : farmerDetails // ignore: cast_nullable_to_non_nullable
                      as FarmerDetails?,
            buyerDetails: freezed == buyerDetails
                ? _value.buyerDetails
                : buyerDetails // ignore: cast_nullable_to_non_nullable
                      as BuyerDetails?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserRoleDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FarmerDetailsCopyWith<$Res>? get farmerDetails {
    if (_value.farmerDetails == null) {
      return null;
    }

    return $FarmerDetailsCopyWith<$Res>(_value.farmerDetails!, (value) {
      return _then(_value.copyWith(farmerDetails: value) as $Val);
    });
  }

  /// Create a copy of UserRoleDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BuyerDetailsCopyWith<$Res>? get buyerDetails {
    if (_value.buyerDetails == null) {
      return null;
    }

    return $BuyerDetailsCopyWith<$Res>(_value.buyerDetails!, (value) {
      return _then(_value.copyWith(buyerDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserRoleDetailsImplCopyWith<$Res>
    implements $UserRoleDetailsCopyWith<$Res> {
  factory _$$UserRoleDetailsImplCopyWith(
    _$UserRoleDetailsImpl value,
    $Res Function(_$UserRoleDetailsImpl) then,
  ) = __$$UserRoleDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<UserRole> roles,
    UserRole activeRole,
    FarmerDetails? farmerDetails,
    BuyerDetails? buyerDetails,
  });

  @override
  $FarmerDetailsCopyWith<$Res>? get farmerDetails;
  @override
  $BuyerDetailsCopyWith<$Res>? get buyerDetails;
}

/// @nodoc
class __$$UserRoleDetailsImplCopyWithImpl<$Res>
    extends _$UserRoleDetailsCopyWithImpl<$Res, _$UserRoleDetailsImpl>
    implements _$$UserRoleDetailsImplCopyWith<$Res> {
  __$$UserRoleDetailsImplCopyWithImpl(
    _$UserRoleDetailsImpl _value,
    $Res Function(_$UserRoleDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserRoleDetails
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
      _$UserRoleDetailsImpl(
        roles: null == roles
            ? _value._roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<UserRole>,
        activeRole: null == activeRole
            ? _value.activeRole
            : activeRole // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        farmerDetails: freezed == farmerDetails
            ? _value.farmerDetails
            : farmerDetails // ignore: cast_nullable_to_non_nullable
                  as FarmerDetails?,
        buyerDetails: freezed == buyerDetails
            ? _value.buyerDetails
            : buyerDetails // ignore: cast_nullable_to_non_nullable
                  as BuyerDetails?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRoleDetailsImpl implements _UserRoleDetails {
  const _$UserRoleDetailsImpl({
    required final List<UserRole> roles,
    required this.activeRole,
    this.farmerDetails,
    this.buyerDetails,
  }) : _roles = roles;

  factory _$UserRoleDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRoleDetailsImplFromJson(json);

  final List<UserRole> _roles;
  @override
  List<UserRole> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final UserRole activeRole;
  @override
  final FarmerDetails? farmerDetails;
  @override
  final BuyerDetails? buyerDetails;

  @override
  String toString() {
    return 'UserRoleDetails(roles: $roles, activeRole: $activeRole, farmerDetails: $farmerDetails, buyerDetails: $buyerDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRoleDetailsImpl &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.activeRole, activeRole) ||
                other.activeRole == activeRole) &&
            (identical(other.farmerDetails, farmerDetails) ||
                other.farmerDetails == farmerDetails) &&
            (identical(other.buyerDetails, buyerDetails) ||
                other.buyerDetails == buyerDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_roles),
    activeRole,
    farmerDetails,
    buyerDetails,
  );

  /// Create a copy of UserRoleDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRoleDetailsImplCopyWith<_$UserRoleDetailsImpl> get copyWith =>
      __$$UserRoleDetailsImplCopyWithImpl<_$UserRoleDetailsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRoleDetailsImplToJson(this);
  }
}

abstract class _UserRoleDetails implements UserRoleDetails {
  const factory _UserRoleDetails({
    required final List<UserRole> roles,
    required final UserRole activeRole,
    final FarmerDetails? farmerDetails,
    final BuyerDetails? buyerDetails,
  }) = _$UserRoleDetailsImpl;

  factory _UserRoleDetails.fromJson(Map<String, dynamic> json) =
      _$UserRoleDetailsImpl.fromJson;

  @override
  List<UserRole> get roles;
  @override
  UserRole get activeRole;
  @override
  FarmerDetails? get farmerDetails;
  @override
  BuyerDetails? get buyerDetails;

  /// Create a copy of UserRoleDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRoleDetailsImplCopyWith<_$UserRoleDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FarmerDetails _$FarmerDetailsFromJson(Map<String, dynamic> json) {
  return _FarmerDetails.fromJson(json);
}

/// @nodoc
mixin _$FarmerDetails {
  List<String> get productTypes => throw _privateConstructorUsedError;
  double get farmArea => throw _privateConstructorUsedError;
  String? get farmLocation => throw _privateConstructorUsedError;
  String? get certificateUrl => throw _privateConstructorUsedError;

  /// Serializes this FarmerDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FarmerDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmerDetailsCopyWith<FarmerDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmerDetailsCopyWith<$Res> {
  factory $FarmerDetailsCopyWith(
    FarmerDetails value,
    $Res Function(FarmerDetails) then,
  ) = _$FarmerDetailsCopyWithImpl<$Res, FarmerDetails>;
  @useResult
  $Res call({
    List<String> productTypes,
    double farmArea,
    String? farmLocation,
    String? certificateUrl,
  });
}

/// @nodoc
class _$FarmerDetailsCopyWithImpl<$Res, $Val extends FarmerDetails>
    implements $FarmerDetailsCopyWith<$Res> {
  _$FarmerDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmerDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productTypes = null,
    Object? farmArea = null,
    Object? farmLocation = freezed,
    Object? certificateUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            productTypes: null == productTypes
                ? _value.productTypes
                : productTypes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            farmArea: null == farmArea
                ? _value.farmArea
                : farmArea // ignore: cast_nullable_to_non_nullable
                      as double,
            farmLocation: freezed == farmLocation
                ? _value.farmLocation
                : farmLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            certificateUrl: freezed == certificateUrl
                ? _value.certificateUrl
                : certificateUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FarmerDetailsImplCopyWith<$Res>
    implements $FarmerDetailsCopyWith<$Res> {
  factory _$$FarmerDetailsImplCopyWith(
    _$FarmerDetailsImpl value,
    $Res Function(_$FarmerDetailsImpl) then,
  ) = __$$FarmerDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> productTypes,
    double farmArea,
    String? farmLocation,
    String? certificateUrl,
  });
}

/// @nodoc
class __$$FarmerDetailsImplCopyWithImpl<$Res>
    extends _$FarmerDetailsCopyWithImpl<$Res, _$FarmerDetailsImpl>
    implements _$$FarmerDetailsImplCopyWith<$Res> {
  __$$FarmerDetailsImplCopyWithImpl(
    _$FarmerDetailsImpl _value,
    $Res Function(_$FarmerDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FarmerDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productTypes = null,
    Object? farmArea = null,
    Object? farmLocation = freezed,
    Object? certificateUrl = freezed,
  }) {
    return _then(
      _$FarmerDetailsImpl(
        productTypes: null == productTypes
            ? _value._productTypes
            : productTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        farmArea: null == farmArea
            ? _value.farmArea
            : farmArea // ignore: cast_nullable_to_non_nullable
                  as double,
        farmLocation: freezed == farmLocation
            ? _value.farmLocation
            : farmLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        certificateUrl: freezed == certificateUrl
            ? _value.certificateUrl
            : certificateUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FarmerDetailsImpl implements _FarmerDetails {
  const _$FarmerDetailsImpl({
    required final List<String> productTypes,
    required this.farmArea,
    this.farmLocation,
    this.certificateUrl,
  }) : _productTypes = productTypes;

  factory _$FarmerDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FarmerDetailsImplFromJson(json);

  final List<String> _productTypes;
  @override
  List<String> get productTypes {
    if (_productTypes is EqualUnmodifiableListView) return _productTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productTypes);
  }

  @override
  final double farmArea;
  @override
  final String? farmLocation;
  @override
  final String? certificateUrl;

  @override
  String toString() {
    return 'FarmerDetails(productTypes: $productTypes, farmArea: $farmArea, farmLocation: $farmLocation, certificateUrl: $certificateUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmerDetailsImpl &&
            const DeepCollectionEquality().equals(
              other._productTypes,
              _productTypes,
            ) &&
            (identical(other.farmArea, farmArea) ||
                other.farmArea == farmArea) &&
            (identical(other.farmLocation, farmLocation) ||
                other.farmLocation == farmLocation) &&
            (identical(other.certificateUrl, certificateUrl) ||
                other.certificateUrl == certificateUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_productTypes),
    farmArea,
    farmLocation,
    certificateUrl,
  );

  /// Create a copy of FarmerDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmerDetailsImplCopyWith<_$FarmerDetailsImpl> get copyWith =>
      __$$FarmerDetailsImplCopyWithImpl<_$FarmerDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FarmerDetailsImplToJson(this);
  }
}

abstract class _FarmerDetails implements FarmerDetails {
  const factory _FarmerDetails({
    required final List<String> productTypes,
    required final double farmArea,
    final String? farmLocation,
    final String? certificateUrl,
  }) = _$FarmerDetailsImpl;

  factory _FarmerDetails.fromJson(Map<String, dynamic> json) =
      _$FarmerDetailsImpl.fromJson;

  @override
  List<String> get productTypes;
  @override
  double get farmArea;
  @override
  String? get farmLocation;
  @override
  String? get certificateUrl;

  /// Create a copy of FarmerDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmerDetailsImplCopyWith<_$FarmerDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BuyerDetails _$BuyerDetailsFromJson(Map<String, dynamic> json) {
  return _BuyerDetails.fromJson(json);
}

/// @nodoc
mixin _$BuyerDetails {
  List<String> get interestedCategories => throw _privateConstructorUsedError;
  String? get companyName => throw _privateConstructorUsedError;
  String? get taxNumber => throw _privateConstructorUsedError;
  String? get businessLocation => throw _privateConstructorUsedError;

  /// Serializes this BuyerDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuyerDetailsCopyWith<BuyerDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuyerDetailsCopyWith<$Res> {
  factory $BuyerDetailsCopyWith(
    BuyerDetails value,
    $Res Function(BuyerDetails) then,
  ) = _$BuyerDetailsCopyWithImpl<$Res, BuyerDetails>;
  @useResult
  $Res call({
    List<String> interestedCategories,
    String? companyName,
    String? taxNumber,
    String? businessLocation,
  });
}

/// @nodoc
class _$BuyerDetailsCopyWithImpl<$Res, $Val extends BuyerDetails>
    implements $BuyerDetailsCopyWith<$Res> {
  _$BuyerDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interestedCategories = null,
    Object? companyName = freezed,
    Object? taxNumber = freezed,
    Object? businessLocation = freezed,
  }) {
    return _then(
      _value.copyWith(
            interestedCategories: null == interestedCategories
                ? _value.interestedCategories
                : interestedCategories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            companyName: freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxNumber: freezed == taxNumber
                ? _value.taxNumber
                : taxNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            businessLocation: freezed == businessLocation
                ? _value.businessLocation
                : businessLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BuyerDetailsImplCopyWith<$Res>
    implements $BuyerDetailsCopyWith<$Res> {
  factory _$$BuyerDetailsImplCopyWith(
    _$BuyerDetailsImpl value,
    $Res Function(_$BuyerDetailsImpl) then,
  ) = __$$BuyerDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> interestedCategories,
    String? companyName,
    String? taxNumber,
    String? businessLocation,
  });
}

/// @nodoc
class __$$BuyerDetailsImplCopyWithImpl<$Res>
    extends _$BuyerDetailsCopyWithImpl<$Res, _$BuyerDetailsImpl>
    implements _$$BuyerDetailsImplCopyWith<$Res> {
  __$$BuyerDetailsImplCopyWithImpl(
    _$BuyerDetailsImpl _value,
    $Res Function(_$BuyerDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interestedCategories = null,
    Object? companyName = freezed,
    Object? taxNumber = freezed,
    Object? businessLocation = freezed,
  }) {
    return _then(
      _$BuyerDetailsImpl(
        interestedCategories: null == interestedCategories
            ? _value._interestedCategories
            : interestedCategories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        companyName: freezed == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxNumber: freezed == taxNumber
            ? _value.taxNumber
            : taxNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        businessLocation: freezed == businessLocation
            ? _value.businessLocation
            : businessLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BuyerDetailsImpl implements _BuyerDetails {
  const _$BuyerDetailsImpl({
    required final List<String> interestedCategories,
    this.companyName,
    this.taxNumber,
    this.businessLocation,
  }) : _interestedCategories = interestedCategories;

  factory _$BuyerDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuyerDetailsImplFromJson(json);

  final List<String> _interestedCategories;
  @override
  List<String> get interestedCategories {
    if (_interestedCategories is EqualUnmodifiableListView)
      return _interestedCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interestedCategories);
  }

  @override
  final String? companyName;
  @override
  final String? taxNumber;
  @override
  final String? businessLocation;

  @override
  String toString() {
    return 'BuyerDetails(interestedCategories: $interestedCategories, companyName: $companyName, taxNumber: $taxNumber, businessLocation: $businessLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuyerDetailsImpl &&
            const DeepCollectionEquality().equals(
              other._interestedCategories,
              _interestedCategories,
            ) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.taxNumber, taxNumber) ||
                other.taxNumber == taxNumber) &&
            (identical(other.businessLocation, businessLocation) ||
                other.businessLocation == businessLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_interestedCategories),
    companyName,
    taxNumber,
    businessLocation,
  );

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuyerDetailsImplCopyWith<_$BuyerDetailsImpl> get copyWith =>
      __$$BuyerDetailsImplCopyWithImpl<_$BuyerDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuyerDetailsImplToJson(this);
  }
}

abstract class _BuyerDetails implements BuyerDetails {
  const factory _BuyerDetails({
    required final List<String> interestedCategories,
    final String? companyName,
    final String? taxNumber,
    final String? businessLocation,
  }) = _$BuyerDetailsImpl;

  factory _BuyerDetails.fromJson(Map<String, dynamic> json) =
      _$BuyerDetailsImpl.fromJson;

  @override
  List<String> get interestedCategories;
  @override
  String? get companyName;
  @override
  String? get taxNumber;
  @override
  String? get businessLocation;

  /// Create a copy of BuyerDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuyerDetailsImplCopyWith<_$BuyerDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
