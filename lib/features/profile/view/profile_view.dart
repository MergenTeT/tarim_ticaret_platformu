import 'package:flutter/material.dart';
import 'package:proje_app/core/base/base_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Profil',
      child: Center(
        child: Text(
          'Profil Sayfası',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class _StatisticsRow extends StatelessWidget {
  const _StatisticsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatisticItem(
          icon: Icons.shopping_basket,
          value: '23',
          label: 'Aktif İlan',
          onTap: () {
            // TODO: Navigate to active listings
          },
        ),
        _StatisticItem(
          icon: Icons.star,
          value: '4.8',
          label: 'Puan',
          onTap: () {
            // TODO: Show rating details
          },
        ),
        _StatisticItem(
          icon: Icons.people,
          value: '156',
          label: 'Takipçi',
          onTap: () {
            // TODO: Show followers
          },
        ),
      ],
    );
  }
}

class _StatisticItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  const _StatisticItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
} 