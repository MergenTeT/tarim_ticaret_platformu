// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  UserRole get primaryRole => throw _privateConstructorUsedError;
  UserRole? get secondaryRole => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  List<String> get favoriteListings => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String email,
    String name,
    UserRole primaryRole,
    UserRole? secondaryRole,
    bool isOnline,
    String? profileImage,
    List<String> favoriteListings,
    DateTime? lastSeen,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? primaryRole = null,
    Object? secondaryRole = freezed,
    Object? isOnline = null,
    Object? profileImage = freezed,
    Object? favoriteListings = null,
    Object? lastSeen = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            primaryRole: null == primaryRole
                ? _value.primaryRole
                : primaryRole // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            secondaryRole: freezed == secondaryRole
                ? _value.secondaryRole
                : secondaryRole // ignore: cast_nullable_to_non_nullable
                      as UserRole?,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
            profileImage: freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            favoriteListings: null == favoriteListings
                ? _value.favoriteListings
                : favoriteListings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            lastSeen: freezed == lastSeen
                ? _value.lastSeen
                : lastSeen // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String name,
    UserRole primaryRole,
    UserRole? secondaryRole,
    bool isOnline,
    String? profileImage,
    List<String> favoriteListings,
    DateTime? lastSeen,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? primaryRole = null,
    Object? secondaryRole = freezed,
    Object? isOnline = null,
    Object? profileImage = freezed,
    Object? favoriteListings = null,
    Object? lastSeen = freezed,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        primaryRole: null == primaryRole
            ? _value.primaryRole
            : primaryRole // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        secondaryRole: freezed == secondaryRole
            ? _value.secondaryRole
            : secondaryRole // ignore: cast_nullable_to_non_nullable
                  as UserRole?,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        profileImage: freezed == profileImage
            ? _value.profileImage
            : profileImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        favoriteListings: null == favoriteListings
            ? _value._favoriteListings
            : favoriteListings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        lastSeen: freezed == lastSeen
            ? _value.lastSeen
            : lastSeen // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl({
    required this.id,
    required this.email,
    required this.name,
    required this.primaryRole,
    this.secondaryRole,
    this.isOnline = false,
    this.profileImage,
    final List<String> favoriteListings = const [],
    this.lastSeen,
  }) : _favoriteListings = favoriteListings;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  final UserRole primaryRole;
  @override
  final UserRole? secondaryRole;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final String? profileImage;
  final List<String> _favoriteListings;
  @override
  @JsonKey()
  List<String> get favoriteListings {
    if (_favoriteListings is EqualUnmodifiableListView)
      return _favoriteListings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteListings);
  }

  @override
  final DateTime? lastSeen;

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, primaryRole: $primaryRole, secondaryRole: $secondaryRole, isOnline: $isOnline, profileImage: $profileImage, favoriteListings: $favoriteListings, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.primaryRole, primaryRole) ||
                other.primaryRole == primaryRole) &&
            (identical(other.secondaryRole, secondaryRole) ||
                other.secondaryRole == secondaryRole) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            const DeepCollectionEquality().equals(
              other._favoriteListings,
              _favoriteListings,
            ) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    name,
    primaryRole,
    secondaryRole,
    isOnline,
    profileImage,
    const DeepCollectionEquality().hash(_favoriteListings),
    lastSeen,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    required final String id,
    required final String email,
    required final String name,
    required final UserRole primaryRole,
    final UserRole? secondaryRole,
    final bool isOnline,
    final String? profileImage,
    final List<String> favoriteListings,
    final DateTime? lastSeen,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  UserRole get primaryRole;
  @override
  UserRole? get secondaryRole;
  @override
  bool get isOnline;
  @override
  String? get profileImage;
  @override
  List<String> get favoriteListings;
  @override
  DateTime? get lastSeen;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
