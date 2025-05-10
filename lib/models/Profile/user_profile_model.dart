import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  String? displayName;
  String? photoUrl;
  String? email;
  String? phoneNumber;
  String location;
  String userId;

  UserProfileModel({
    this.displayName,
    this.photoUrl,
    this.email,
    this.phoneNumber,
    this.location = "Loading location...",
    required this.userId,
  });

  // Factory constructor to create a model from Firebase User
  factory UserProfileModel.fromUser(User user) {
    return UserProfileModel(
      displayName: user.displayName,
      photoUrl: user.photoURL,
      email: user.email,
      userId: user.uid,
    );
  }

  // Factory constructor to create a model from Firestore data
  factory UserProfileModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, User user) {
    final data = snapshot.data();
    return UserProfileModel(
      displayName: user.displayName,
      photoUrl: user.photoURL,
      email: user.email,
      phoneNumber: data?['phoneNumber'],
      userId: user.uid,
    );
  }

  // Convert model to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
    };
  }

  // Update display name
  void updateDisplayName(String name) {
    displayName = name;
  }

  // Update phone number
  void updatePhoneNumber(String phone) {
    phoneNumber = phone;
  }

  // Update photo URL
  void updatePhotoUrl(String url) {
    photoUrl = url;
  }

  // Update location
  void updateLocation(String newLocation) {
    location = newLocation;
  }
}