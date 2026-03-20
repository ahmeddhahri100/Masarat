import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('App Preferences', style: MasaratTypography.labelMedium),
          const SizedBox(height: 16),
          _SettingsContainer(
            children: [
              _SettingsToggle(
                icon: Icons.notifications_active_outlined,
                title: 'Push Notifications',
                value: true,
              ),
              _SettingsToggle(
                icon: Icons.notifications_paused_outlined,
                title: 'Silence at Night',
                value: false,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text('Support & Legal', style: MasaratTypography.labelMedium),
          const SizedBox(height: 16),
          _SettingsContainer(
            children: [
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                title: 'Help Center',
              ),
              _SettingsTile(
                icon: Icons.policy_outlined,
                title: 'Terms of Service',
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
              ),
            ],
          ),
          const SizedBox(height: 48),
          Center(
            child: Column(
              children: [
                Text(
                  'Masarat Carpooling',
                  style: MasaratTypography.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.2.0',
                  style: MasaratTypography.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsContainer extends StatelessWidget {
  final List<Widget> children;
  const _SettingsContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MasaratColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MasaratColors.onSurface.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 64,
                  endIndent: 20,
                  color: MasaratColors.outlineVariant.withOpacity(0.3),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: MasaratColors.primaryFixed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: MasaratColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: MasaratTypography.labelLarge),
          ),
          Switch.adaptive(
            value: value,
            onChanged: (v) {},
            activeTrackColor: MasaratColors.primary.withOpacity(0.5),
            activeColor: MasaratColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SettingsTile({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: MasaratColors.secondaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: MasaratColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: MasaratTypography.labelLarge),
            ),
            Icon(Icons.chevron_right_rounded,
                color: MasaratColors.outlineVariant, size: 20),
          ],
        ),
      ),
    );
  }
}
