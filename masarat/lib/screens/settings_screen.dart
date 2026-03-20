import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Preferences', style: MasaratTypography.labelMedium),
          const SizedBox(height: 16),
          _SettingsToggle(title: 'Push Notifications', value: true),
          _SettingsToggle(title: 'Realtime Trip Alerts', value: true),
          const SizedBox(height: 32),
          Text('Support & Legal', style: MasaratTypography.labelMedium),
          const SizedBox(height: 16),
          _SettingsTile(title: 'Help Center'),
          _SettingsTile(title: 'Terms of Community Service'),
          _SettingsTile(title: 'Privacy Policy'),
          const SizedBox(height: 48),
          Center(
            child: Text('Masarat Version 1.0.0 (MVP)', style: MasaratTypography.labelMedium.copyWith(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final String title;
  final bool value;
  const _SettingsToggle({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: (v) {},
      title: Text(title, style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      activeColor: MasaratColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  const _SettingsTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, size: 16),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
    );
  }
}
