import 'package:flutter/material.dart';
import '../../controllers/Auth/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController;

  const ProfileScreen({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
          ),
          SizedBox(height: 20),
          Text(
            //TODO: Replace with real name
            'Guest',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            //TODO: Replace with real email
            'No email',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}