import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import '../core/theme/colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    try {
      // Clerk Sign In Logic Placeholder
      // final signIn = await Clerk.signIn.create(
      //   identifier: _emailController.text,
      //   password: _passwordController.text,
      // );
      // Handle Success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(
              'Sign in to coordinate your next shared trip.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MasaratColors.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@example.com',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 48),
            const ClerkAuthentication(),
          ],
        ),
      ),
    );
  }
}
