enum UserRole {
  farmer('Çiftçi'),
  buyer('Alıcı'),
  farmerBuyer('Çiftçi-Alıcı');

  final String label;
  const UserRole(this.label);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.toString().split('.').last == value,
      orElse: () => UserRole.buyer,
    );
  }
} 