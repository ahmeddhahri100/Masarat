import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _ConversationItem(
            name: 'Sami Rebai',
            lastMessage: 'I will be at the TGM station at 8.',
            time: '14:20',
            isUnread: true,
            tripRoute: 'Tunis → Hammamet',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _ConversationItem(
            name: 'Fatma B.',
            lastMessage: 'Request accepted! See you tomorrow.',
            time: '13:05',
            isUnread: false,
            tripRoute: 'Ariana → Sousse',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _ConversationItem(
            name: 'Mohamed K.',
            lastMessage: 'Thanks for the ride!',
            time: 'Yesterday',
            isUnread: false,
            tripRoute: 'Bizerte → Tunis',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool isUnread;
  final String tripRoute;
  final VoidCallback onTap;

  const _ConversationItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isUnread,
    required this.tripRoute,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnread
                ? MasaratColors.primaryFixed.withOpacity(0.3)
                : MasaratColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: MasaratColors.onSurface.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: isUnread
                      ? MasaratColors.primaryGradient
                      : const LinearGradient(
                          colors: [MasaratColors.secondaryFixed, MasaratColors.secondaryFixed]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color:
                      isUnread ? Colors.white : MasaratColors.onSecondaryFixed,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: MasaratTypography.labelLarge),
                    const SizedBox(height: 2),
                    Text(
                      tripRoute,
                      style: MasaratTypography.labelSmall.copyWith(
                        color: MasaratColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
                      style: MasaratTypography.bodyMedium.copyWith(
                        color: isUnread
                            ? MasaratColors.onSurface
                            : MasaratColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(time, style: MasaratTypography.labelSmall),
                  const SizedBox(height: 8),
                  if (isUnread)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: MasaratColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
