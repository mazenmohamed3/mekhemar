import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mekhemar/controllers/Features/Location/Controller/location_controller.dart';
import 'package:mekhemar/controllers/Pages/Auth/sources/auth_datasource.dart';
import 'package:mekhemar/views/components/Snack%20Bar/success_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../models/Profile/user_profile_model.dart';
import '../../../../../../../views/components/Dialog/phone_number_input_dialog.dart';
import '../../../../../../../views/components/Dialog/select_image_dialog.dart';
import '../../../../../../../views/components/Snack Bar/failed_snackbar.dart';
import '../../../../../../Features/Cloud Image/Controller/cloudinary_controller.dart';
import '../services/profile_update_service.dart';

class ProfileController {
  ProfileController({
    required AuthDatasource authDatasource,
    required LocationController locationController,
    required CloudinaryController cloudinaryController,
  }) : _authDatasource = authDatasource,
       _locationController = locationController,
       _cloudinaryController = cloudinaryController,
       _profileNotifier = ProfileUpdateNotifier(); // Initialize the notifier

  final AuthDatasource _authDatasource;
  final LocationController _locationController;
  final CloudinaryController _cloudinaryController;
  final ProfileUpdateNotifier _profileNotifier; // Add the notifier
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late void Function(void Function()) setProfileState;
  late void Function(void Function()) setPhoneState;
  late void Function(void Function()) setLocationState;

  User? _user;
  UserProfileModel? _userProfile; // New user profile model

  // Getters for profile data
  String? get displayName => _userProfile?.displayName;

  String? get photoUrl => _userProfile?.photoUrl;

  String? get email => _userProfile?.email;

  String get location => _userProfile?.location ?? "locationLoading".tr();

  String get phone => _userProfile?.phoneNumber ?? 'noPhone'.tr();

  Future<void> initState() async {
    _user = _auth.currentUser;

    if (_user != null) {
      // Initialize the model with user data
      _userProfile = UserProfileModel.fromUser(_user!);

      // Fetch phone number from Firestore
      final phoneNumber = await _getPhoneNumberFromFirestore();
      if (phoneNumber != null) {
        setPhoneState(() {
          _userProfile!.updatePhoneNumber(phoneNumber);
        });
      }

      // Get location
      final currentLocation = await _locationController.getCurrentLocation();
      setLocationState(() {
        _userProfile!.updateLocation(currentLocation);
      });
    }
  }

  void onProfileTap(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const SelectImageDialog(),
    );
    if (result != null && context.mounted) {
      await handleImageSelection(context, result);
    }
  }

  void Function()? onPhoneTap(BuildContext context) {
    if (phone == 'Press to Add Phone') {
      return () async {
        // Step 1: Enter Phone Number
        final newPhone = await showDialog<String>(
          context: context,
          builder: (context) => PhoneNumberInputDialog(),
        );

        if (newPhone != null && newPhone.isNotEmpty) {
          if (!context.mounted) return;

          // Step 2: Save phone number to Firestore
          await updatePhoneNumberInFirestore(
            context: context,
            phoneNumber: newPhone,
          );
        }
      };
    } else {
      return null;
    }
  }

  Future<bool> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) return false;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final photosStatus = await Permission.photos.request();
      if (!photosStatus.isGranted) return false;
    }

    return true;
  }

  Future<void> handleImageSelection(
    BuildContext context,
    bool fromGallery,
  ) async {
    final permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      if (!context.mounted) return;
      showFailedSnackBar(context, title: "pleaseGrantPermissions");
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    );

    if (image == null) {
      if (context.mounted) {
        showFailedSnackBar(context, title: "noImageSelected");
      }
      return;
    }

    try {
      final newPhotoUrl = await _cloudinaryController.uploadImageToCloudinary(
        File(image.path),
      );
      if (newPhotoUrl != null) {
        await _user!.updatePhotoURL(newPhotoUrl);
        await _user!.reload();
        _user = FirebaseAuth.instance.currentUser;

        // Update the model
        _userProfile!.updatePhotoUrl(newPhotoUrl);

        // Notify other parts of the app about the profile photo update
        _profileNotifier.notifyProfileUpdate(
          ProfileUpdateEvent(userId: _user!.uid, photoUrl: newPhotoUrl),
        );

        if (context.mounted) {
          showSuccessSnackBar(context, title: "profilePhotoUpdated");
          setProfileState(() {});
        }
      } else {
        if (context.mounted) {
          showFailedSnackBar(context, title: "failedToUploadCloudinary");
        }
      }
    } catch (e) {
      if (context.mounted) {
        showFailedSnackBar(context, title: "uploadError", args: [e.toString()]);
      }
    }
  }

  /// ---- PHONE NUMBER FLOW ----

  Future<void> updatePhoneNumberInFirestore({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      // Save phone number to Firestore
      await _firestore.collection('users').doc(_user!.uid).set(
        {'phoneNumber': phoneNumber},
        SetOptions(merge: true),
      ); // Added merge option to not overwrite other fields

      // Update the model
      _userProfile!.updatePhoneNumber(phoneNumber);

      // Notify other parts of the app about the phone number update
      _profileNotifier.notifyProfileUpdate(
        ProfileUpdateEvent(userId: _user!.uid, phoneNumber: phoneNumber),
      );

      // If update is successful
      if (context.mounted) {
        showSuccessSnackBar(context, title: 'phoneNumberUpdated');
        setPhoneState(() {});
      }
    } catch (e) {
      if (context.mounted) {
        showFailedSnackBar(
          context,
          title: 'phoneNumberUpdateFailed',
          args: [e.toString()],
        );
      }
    }
  }

  // Fetch the phone number from Firestore
  Future<String?> _getPhoneNumberFromFirestore() async {
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.data()?['phoneNumber'];
      }
    } catch (e) {
      print('Error fetching phone number from Firestore: $e');
    }
    return null;
  }

  void logout(BuildContext context) {
    _authDatasource.logout(context);
  }
}
