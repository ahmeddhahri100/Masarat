import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sami Rebai', style: MasaratTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            Text('Trip to Hammamet', style: MasaratTypography.labelMedium.copyWith(fontSize: 10)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: const [
                _MessageBubble(text: 'Hello! I requested a seat for your trip tomorrow.', isMe: true, time: '10:00 AM'),
                _MessageBubble(text: 'Welcome! I will be at the TGM station at 8.', isMe: false, time: '10:05 AM'),
                _SystemMessage(text: 'Request accepted by Sami'),
              ],
            ),
          ),
          _ChatInput(),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const _MessageBubble({required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? MasaratColors.primary : MasaratColors.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: MasaratTypography.bodyMedium.copyWith(color: isMe ? Colors.white : MasaratColors.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: MasaratTypography.labelMedium.copyWith(
                fontSize: 10,
                color: isMe ? Colors.white70 : MasaratColors.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemMessage extends StatelessWidget {
  final String text;
  const _SystemMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: MasaratColors.secondaryFixed.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
          child: Text(text, style: MasaratTypography.labelMedium.copyWith(color: MasaratColors.onSecondaryFixed)),
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: MasaratColors.outlineVariant.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                filled: true,
                fillColor: MasaratColors.surfaceContainerLow,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: MasaratColors.primary,
            child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
