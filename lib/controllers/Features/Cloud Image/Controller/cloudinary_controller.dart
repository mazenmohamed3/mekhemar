import 'dart:io';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudinaryController {
  final Cloudinary cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://${dotenv.env['CLOUDINARY_API_KEY']}:${dotenv.env['CLOUDINARY_API_KEY_SECRET']}@${dotenv.env['CLOUDINARY_CLOUD_NAME']}',
  );

  CloudinaryController() {
    cloudinary.config.urlConfig.secure = true;
  }

  Future<String?> uploadImageToCloudinary(File file) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in.");
        return null;
      }

      final String userId = user.uid;
      final String publicId = 'profile_image_of_$userId';

      // Create the upload request
      final uploader = cloudinary.uploader();
      final response = await uploader.upload(
        file,
        params: UploadParams(publicId: publicId, overwrite: true),
      );

      if (response?.data?.secureUrl != null) {
        final secureUrl = response?.data?.secureUrl;
        print("Uploaded to Cloudinary: $secureUrl");
        return secureUrl;
      } else {
        print("Upload failed: ${response?.data}");
        return null;
      }
    } catch (e) {
      print("Error uploading to Cloudinary: $e");
      return null;
    }
  }
}