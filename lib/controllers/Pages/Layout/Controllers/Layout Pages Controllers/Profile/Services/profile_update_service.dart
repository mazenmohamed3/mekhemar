// lib/controllers/notifications/profile_update_notifier.dart

import 'dart:async';

/// A simple notification system for broadcasting profile updates across the app.
///
/// This class follows the Singleton pattern to ensure a single instance is used app-wide.
class ProfileUpdateService {
  // Singleton instance
  static final ProfileUpdateService _instance = ProfileUpdateService._internal();

  // Factory constructor to return the singleton instance
  factory ProfileUpdateService() => _instance;

  // Private constructor for singleton
  ProfileUpdateService._internal();

  // StreamController for profile updates
  final _profileUpdateController = StreamController<ProfileUpdateEvent>.broadcast();

  // Stream that other widgets/controllers can listen to
  Stream<ProfileUpdateEvent> get profileUpdates => _profileUpdateController.stream;

  // Method to notify listeners when profile changes
  void notifyProfileUpdate(ProfileUpdateEvent event) {
    _profileUpdateController.add(event);
  }

  // Clean up resources
  void dispose() {
    _profileUpdateController.close();
  }
}

/// Event class containing profile update information
class ProfileUpdateEvent {
  final String userId;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;

  ProfileUpdateEvent({
    required this.userId,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });
}