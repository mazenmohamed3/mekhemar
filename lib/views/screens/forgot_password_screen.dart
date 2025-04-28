import 'package:flutter/material.dart';
import '../../controllers/Auth/auth_controller.dart';
import '../widgets/reusable_widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final AuthController authController;

  const ForgotPasswordScreen({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const LogoWidget(size: 100),
            const SizedBox(height: 20),
            const Text('Enter your email to reset password'),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              label: "Email",
              validator: (value) =>
              value!.contains('@') ? null : 'Invalid email',
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Send Reset Link',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reset link sent')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}