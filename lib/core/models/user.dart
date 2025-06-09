import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// Timestamp'i DateTime'a çeviren converter
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    required UserRole primaryRole,
    UserRole? secondaryRole,
    @Default(false) bool isOnline,
    String? profileImage,
    @Default([]) List<String> favoriteListings,
    @TimestampConverter() DateTime? lastSeen,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    String? phoneNumber,
    String? city,
    String? deviceToken,
    @Default(true) bool notificationsEnabled,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static User empty() => User(
        id: '',
        email: '',
        name: '',
        primaryRole: UserRole.buyer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  const User._();

  // Kullanıcının çiftçi olup olmadığını kontrol eder
  bool get isFarmer => primaryRole == UserRole.farmer || primaryRole == UserRole.farmerBuyer;

  // Kullanıcının alıcı olup olmadığını kontrol eder
  bool get isBuyer => primaryRole == UserRole.buyer || primaryRole == UserRole.farmerBuyer;

  // Kullanıcının çiftçi-alıcı olup olmadığını kontrol eder
  bool get isFarmerBuyer => primaryRole == UserRole.farmerBuyer;

  // Kullanıcının ikinci bir rolü olup olmadığını kontrol eder
  bool get hasSecondaryRole => secondaryRole != null;

  // Kullanıcının profil fotoğrafı olup olmadığını kontrol eder
  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;

  // Kullanıcının telefon numarası olup olmadığını kontrol eder
  bool get hasPhoneNumber => phoneNumber != null && phoneNumber!.isNotEmpty;

  // Kullanıcının şehir bilgisi olup olmadığını kontrol eder
  bool get hasCity => city != null && city!.isNotEmpty;

  // Kullanıcının push notification token'ı olup olmadığını kontrol eder
  bool get hasDeviceToken => deviceToken != null && deviceToken!.isNotEmpty;
} 