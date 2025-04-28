// lib/views/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notification Settings'),
        ),
        ListTile(
          leading: Icon(Icons.security),
          title: Text('Privacy Settings'),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('About App'),
        ),
      ],
    );
  }
}