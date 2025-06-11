import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.g.dart';
part 'role_model.freezed.dart';

@freezed
class RoleModel with _$RoleModel {
  const factory RoleModel({
    required String id,
    required String name,
    required String description,
    required bool isActive,
    required DateTime createdAt,
    @Default(false) bool isDefault,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
} 