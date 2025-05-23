import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../models/Profile/user_profile_model.dart';
import '../../../../../../../views/components/Dialog/phone_number_input_dialog.dart';
import '../../../../../../../views/components/Dialog/select_image_dialog.dart';
import '../../../../../../../views/components/Snack Bar/failed_snackbar.dart';
import '../../../../../../../views/components/Snack Bar/success_snackbar.dart';
import '../../../../../../Features/Cloud Image/Controller/cloudinary_controller.dart';
import '../../../../../../Features/Location/Controller/location_controller.dart';
import '../../../../../Auth/sources/auth_datasource.dart';
import '../../Settings/Services/settings_update_service.dart';
import '../services/profile_update_service.dart';

class ProfileController {
  ProfileController({
    required AuthDatasource authDatasource,
    required LocationController locationController,
    required CloudinaryController cloudinaryController,
  }) : _authDatasource = authDatasource,
       _locationController = locationController,
       _cloudinaryController = cloudinaryController,
       _profileNotifierService = ProfileUpdateService(),
       _settingsNotifierService =
           SettingsUpdateService(); // <-- initialize service

  final AuthDatasource _authDatasource;
  final LocationController _locationController;
  final CloudinaryController _cloudinaryController;
  final ProfileUpdateService _profileNotifierService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SettingsUpdateService _settingsNotifierService;

  late StreamSubscription<SettingsUpdateEvent> _settingsSubscription;

  late void Function(void Function()) setProfileState;
  late void Function(void Function()) setPhoneState;
  late void Function(void Function()) setLocationState;
  late void Function(void Function()) setDisplayNameState;

  User? _user;
  UserProfileModel? _userProfile;

  String? get displayName => _userProfile?.displayName;

  String? get photoUrl => _userProfile?.photoUrl;

  String? get email => _userProfile?.email;

  String get location => _userProfile?.location ?? "locationLoading".tr();

  String get phone => _userProfile?.phoneNumber ?? 'noPhone'.tr();

  Future<void> initState() async {
    _user = _auth.currentUser;

    if (_user != null) {
      _userProfile = UserProfileModel.fromUser(_user!);

      final phoneNumber = await _getPhoneNumberFromFirestore();
      if (phoneNumber != null) {
        setPhoneState(() {
          _userProfile!.updatePhoneNumber(phoneNumber);
        });
      }

      final currentLocation = await _locationController.getCurrentLocation();
      setLocationState(() {
        _userProfile!.updateLocation(currentLocation);
      });
    }

    // Start listening to username updates
    _settingsSubscription = _settingsNotifierService.settingsUpdates.listen(
      _handleSettingsUpdate,
    );
  }

  void _handleSettingsUpdate(SettingsUpdateEvent event) async {
    if (event.updateType == SettingsUpdateType.username ||
        event.updateType == SettingsUpdateType.all) {
      await _refreshDisplayName();
    }
  }

  Future<void> _refreshDisplayName() async {
    await _user?.reload();
    _user = FirebaseAuth.instance.currentUser;
    final newName = _user?.displayName;

    print('New Display Name: $newName');
    if (newName != null && newName.isNotEmpty) {
      setDisplayNameState(() {
        _userProfile?.updateDisplayName(newName);
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
    if (phone == 'noPhone'.tr()) {
      return () async {
        final newPhone = await showDialog<String>(
          context: context,
          builder: (context) => PhoneNumberInputDialog(),
        );

        if (newPhone != null && newPhone.isNotEmpty) {
          if (!context.mounted) return;

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

        _userProfile!.updatePhotoUrl(newPhotoUrl);

        _profileNotifierService.notifyProfileUpdate(
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

  Future<void> updatePhoneNumberInFirestore({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(_user!.uid).set({
        'phoneNumber': phoneNumber,
      }, SetOptions(merge: true));

      _userProfile!.updatePhoneNumber(phoneNumber);

      _profileNotifierService.notifyProfileUpdate(
        ProfileUpdateEvent(userId: _user!.uid, phoneNumber: phoneNumber),
      );

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

  void dispose() {
    _settingsSubscription.cancel();
  }
}
