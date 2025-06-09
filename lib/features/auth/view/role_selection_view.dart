import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/enums/user_role.dart';
import '../viewmodel/auth_viewmodel.dart';

class RoleSelectionView extends ConsumerStatefulWidget {
  const RoleSelectionView({Key? key}) : super(key: key);

  @override
  ConsumerState<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends ConsumerState<RoleSelectionView> {
  UserRole? selectedRole;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rol Seçimi'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              'Hoş Geldiniz!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Lütfen platformdaki rolünüzü seçin',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildRoleCard(
              role: UserRole.farmer,
              icon: Icons.agriculture,
              description: 'Ürünlerinizi satmak için ilan verebilirsiniz',
            ),
            const SizedBox(height: 16),
            _buildRoleCard(
              role: UserRole.buyer,
              icon: Icons.shopping_cart,
              description: 'Ürün satın alma talebi oluşturabilirsiniz',
            ),
            const SizedBox(height: 16),
            _buildRoleCard(
              role: UserRole.farmerBuyer,
              icon: Icons.swap_horiz,
              description: 'Hem alım hem satım yapabilirsiniz',
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: selectedRole == null ? null : _handleRoleSelection,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Devam Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required IconData icon,
    required String description,
  }) {
    final isSelected = selectedRole == role;

    return InkWell(
      onTap: () => setState(() => selectedRole = role),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRoleSelection() async {
    if (selectedRole == null) return;

    try {
      // Show loading indicator
      setState(() => _isLoading = true);

      // Update user role
      await ref.read(authViewModelProvider.notifier).updateRole(selectedRole!);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rol seçimi başarılı!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to market page
        context.go('/market');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
} 