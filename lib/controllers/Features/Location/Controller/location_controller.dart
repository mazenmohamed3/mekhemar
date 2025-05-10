import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController {
  static Future<void> init() async {
    await Geolocator.requestPermission();
  }

  // Function to fetch the current location and return it as a formatted string
  Future<String> getCurrentLocation() async {
    // Check if location Services are enabled
    bool controllerEnabled = await Geolocator.isLocationServiceEnabled();
    if (!controllerEnabled) {
      // return "Location Services are disabled";
    }

    // Request location permissions
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // return "Location permission denied";
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    // Convert the position to an address (placemark)
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark placemark = placemarks.first;

    // Return the full address format
    return "${placemark.name ?? ''}, "
            "${placemark.administrativeArea ?? ''}, "
            "${placemark.country ?? ''}"
        .replaceAll(RegExp(r', +,'), ',')
        .trim();
  }
}