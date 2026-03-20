import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MasaratColors.surface,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Portrait edit
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: MasaratColors.primaryFixed,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(Icons.person_rounded, 
                    color: MasaratColors.primary, size: 50),
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: MasaratColors.primary,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.camera_alt_rounded, 
                      color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            const TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                alignLabelWithHint: true,
                hintText: 'Tell the community a bit about yourself...',
              ),
            ),
            
            const SizedBox(height: 48),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: MasaratColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: MasaratColors.primary.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text('Save Changes', 
                    style: MasaratTypography.buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
