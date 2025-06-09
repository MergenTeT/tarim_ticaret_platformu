import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../viewmodel/profile_viewmodel.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final displayNameController = useTextEditingController();
    final isEditing = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditing.value ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing.value) {
                ref.read(profileViewModelProvider.notifier).updateProfile(
                      displayName: displayNameController.text,
                    );
              }
              isEditing.value = !isEditing.value;
            },
          ),
        ],
      ),
      body: profileState.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile data available'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profile.photoURL != null
                          ? CachedNetworkImageProvider(profile.photoURL!)
                          : null,
                      child: profile.photoURL == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18),
                          color: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () {
                            // TODO: Implement photo upload
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              if (isEditing.value) ...[
                TextField(
                  controller: displayNameController..text = profile.displayName ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Name'),
                  subtitle: Text(profile.displayName ?? 'Not set'),
                ),
              ],
              const Gap(16),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(profile.email),
                trailing: profile.emailVerified
                    ? const Icon(Icons.verified, color: Colors.green)
                    : TextButton(
                        onPressed: () {
                          ref.read(profileViewModelProvider.notifier).verifyEmail();
                        },
                        child: const Text('Verify'),
                      ),
              ),
              if (profile.phoneNumber != null) ...[
                const Gap(16),
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: const Text('Phone'),
                  subtitle: Text(profile.phoneNumber!),
                ),
              ],
              const Gap(16),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Member Since'),
                subtitle: Text(
                  profile.createdAt?.toLocal().toString().split('.').first ?? 'Unknown',
                ),
              ),
              const Gap(16),
              ListTile(
                leading: const Icon(Icons.access_time_outlined),
                title: const Text('Last Sign In'),
                subtitle: Text(
                  profile.lastSignInTime?.toLocal().toString().split('.').first ?? 'Unknown',
                ),
              ),
            ],
          );
        },
        loading: () => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
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