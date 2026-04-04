import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../services/supabase_service.dart';
import '../services/clerk_auth_service.dart';
import '../models/message_model.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String? tripId;
  final String? otherUserId;
  final String? otherUserName;
  const ChatScreen({super.key, this.tripId, this.otherUserId, this.otherUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userId = ClerkAuthService.userId;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text('Please sign in to chat')));
    }

    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(
        backgroundColor: MasaratColors.surfaceContainerLowest,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: MasaratColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUserName ?? 'Partner',
                    style: MasaratTypography.labelLarge),
                Text('Trip Chat',
                    style: MasaratTypography.labelSmall.copyWith(
                      color: MasaratColors.primary,
                    )),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.tripId == null 
              ? const Center(child: Text('No trip associated with this chat'))
              : StreamBuilder<List<MessageModel>>(
                stream: SupabaseService.getMessagesStream(widget.tripId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data ?? [];
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return _MessageBubble(
                        text: msg.content,
                        isMe: msg.senderId == userId,
                        time: '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                      );
                    },
                  );
                },
              ),
          ),
          _ChatInput(
            controller: _messageController,
            onSend: () => _sendMessage(userId),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String userId) async {
    if (_messageController.text.isEmpty || widget.tripId == null || widget.otherUserId == null) return;

    final content = _messageController.text;
    _messageController.clear();

    final message = MessageModel(
      id: const Uuid().v4(),
      senderId: userId,
      receiverId: widget.otherUserId!,
      content: content,
      timestamp: DateTime.now(),
      tripId: widget.tripId,
    );

    await SupabaseService.sendMessage(message);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  const _MessageBubble(
      {required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          gradient: isMe ? MasaratColors.primaryGradient : null,
          color: isMe ? null : MasaratColors.surfaceContainerLowest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: MasaratColors.onSurface.withOpacity(0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: MasaratTypography.bodyMedium.copyWith(
                color: isMe ? Colors.white : MasaratColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: MasaratTypography.labelSmall.copyWith(
                fontSize: 10,
                color: isMe ? Colors.white70 : MasaratColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _ChatInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: MasaratColors.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: MasaratColors.onSurface.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: MasaratColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: MasaratTypography.bodyMedium.copyWith(
                    color: MasaratColors.onSurfaceVariant.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: MasaratColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: MasaratColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
