import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

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
    DateTime? lastSeen,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static User empty() => const User(
        id: '',
        email: '',
        name: '',
        primaryRole: UserRole.buyer,
      );
} 