import 'package:flutter/material.dart';
import 'package:proje_app/core/base/base_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Ayarlar',
      showBottomNav: false,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Bildirim Ayarları'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Dil Seçenekleri'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to language settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Gizlilik ve Güvenlik'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to privacy settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Yardım ve Destek'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to help and support
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Hakkında'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to about
            },
          ),
        ],
      ),
    );
  }
} 