import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../model/role_model.dart';

final rolesProvider = StateNotifierProvider<RolesNotifier, List<RoleModel>>((ref) {
  return RolesNotifier();
});

final activeRoleProvider = StateProvider<RoleModel?>((ref) => null);

class RolesNotifier extends StateNotifier<List<RoleModel>> {
  RolesNotifier() : super([
    RoleModel(
      id: '1',
      name: 'Çiftçi',
      description: 'Tarım ürünleri üreticisi',
      isActive: true,
      createdAt: DateTime.now(),
      isDefault: true,
    ),
    RoleModel(
      id: '2',
      name: 'Tüccar',
      description: 'Tarım ürünleri alım-satımı yapan kişi',
      isActive: false,
      createdAt: DateTime.now(),
    ),
    RoleModel(
      id: '3',
      name: 'Kooperatif',
      description: 'Tarım kooperatifi yetkilisi',
      isActive: false,
      createdAt: DateTime.now(),
    ),
  ]);

  void addRole(RoleModel role) {
    state = [...state, role];
  }

  void removeRole(String roleId) {
    state = state.where((role) => role.id != roleId).toList();
  }

  void updateRole(RoleModel updatedRole) {
    state = state.map((role) {
      return role.id == updatedRole.id ? updatedRole : role;
    }).toList();
  }

  void setActiveRole(String roleId) {
    state = state.map((role) {
      return role.copyWith(isActive: role.id == roleId);
    }).toList();
  }
} 