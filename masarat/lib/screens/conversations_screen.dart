import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../services/supabase_service.dart';
import '../services/clerk_auth_service.dart';
import '../models/message_model.dart';
import '../screens/welcome_screen.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = ClerkAuthService.userId;

    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(
        backgroundColor: MasaratColors.surface,
        elevation: 0,
        title: Text('Messages', style: MasaratTypography.headlineSmall),
      ),
      body: userId == null
          ? _buildGuestView(context)
          : FutureBuilder<List<ConversationModel>>(
              future: SupabaseService.getUserConversations(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final conversations = snapshot.data ?? [];
                if (conversations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            size: 64,
                            color: MasaratColors.onSurfaceVariant.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('No conversations yet',
                            style: MasaratTypography.bodyLarge),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: conversations.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final conv = conversations[index];
                    return _ConversationItem(
                      name: conv.otherUserName,
                      lastMessage: conv.lastMessage,
                      time: '${conv.lastMessageTime.hour}:${conv.lastMessageTime.minute.toString().padLeft(2, '0')}',
                      isUnread: conv.isUnread,
                      tripRoute: conv.tripRoute ?? 'Unknown Route',
                      avatarUrl: conv.otherUserAvatar,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            tripId: null,
                            otherUserId: conv.otherUserId,
                            otherUserName: conv.otherUserName,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline_rounded,
                size: 72, color: MasaratColors.onSurfaceVariant.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('Sign in to view your messages',
                style: MasaratTypography.bodyLarge),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('Go to Sign In'),
            ),
          ],
        ),
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
  final String? avatarUrl;
  final VoidCallback onTap;

  const _ConversationItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isUnread,
    required this.tripRoute,
    this.avatarUrl,
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
                      : const LinearGradient(colors: [
                          MasaratColors.secondaryFixed,
                          MasaratColors.secondaryFixed
                        ]),
                  borderRadius: BorderRadius.circular(14),
                  image: avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: avatarUrl == null
                    ? Icon(
                        Icons.person_rounded,
                        color: isUnread
                            ? Colors.white
                            : MasaratColors.onSecondaryFixed,
                        size: 22,
                      )
                    : null,
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
