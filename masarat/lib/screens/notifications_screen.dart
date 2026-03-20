import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final isNew = index < 2;
          return _NotificationItem(
            isNew: isNew,
            icon: index == 0 ? Icons.check_circle_rounded : Icons.message_rounded,
            title: index == 0 ? 'Trip Request Accepted' : 'New Message from Sami',
            subtitle: index == 0 
              ? 'Your request to join the trip to Hammamet was accepted.'
              : 'I will be at the TGM station at 8.',
            time: '2h ago',
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final bool isNew;
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _NotificationItem({
    required this.isNew,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew 
          ? MasaratColors.primaryFixed.withOpacity(0.3)
          : MasaratColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MasaratColors.onSurface.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isNew ? MasaratColors.primary : MasaratColors.primaryFixed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, 
              color: isNew ? Colors.white : MasaratColors.primary, 
              size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: MasaratTypography.labelLarge),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: MasaratColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, 
                  style: MasaratTypography.bodyMedium.copyWith(
                    fontSize: 13,
                    color: MasaratColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(time, style: MasaratTypography.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
