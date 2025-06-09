import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    @Default(false) bool emailVerified,
    DateTime? createdAt,
    DateTime? lastSignInTime,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
} 