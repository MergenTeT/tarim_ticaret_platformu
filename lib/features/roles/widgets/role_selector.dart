import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/role_provider.dart';
import '../model/role_model.dart';
import 'package:gap/gap.dart';

class RoleSelector extends ConsumerWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(rolesProvider);
    final activeRole = roles.firstWhere((role) => role.isActive);

    return PopupMenuButton<RoleModel>(
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_outline,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Gap(4),
            Text(
              activeRole.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const Gap(2),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        ...roles.map(
          (role) => PopupMenuItem<RoleModel>(
            value: role,
            child: ListTile(
              dense: true,
              leading: role.isActive
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    )
                  : const Icon(Icons.circle_outlined, size: 20),
              title: Text(role.name),
              subtitle: Text(
                role.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<RoleModel>(
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.add_circle_outline, size: 20),
            title: const Text('Yeni Rol Ekle'),
            onTap: () {
              Navigator.pop(context);
              _showAddRoleDialog(context, ref);
            },
          ),
        ),
      ],
      onSelected: (RoleModel selectedRole) {
        ref.read(rolesProvider.notifier).setActiveRole(selectedRole.id);
      },
    );
  }

  void _showAddRoleDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Rol Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Rol Adı',
                hintText: 'Örn: Toptancı',
              ),
            ),
            const Gap(16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                hintText: 'Rolün kısa açıklaması',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                final newRole = RoleModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text,
                  isActive: false,
                  createdAt: DateTime.now(),
                );
                ref.read(rolesProvider.notifier).addRole(newRole);
                Navigator.pop(context);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
} 