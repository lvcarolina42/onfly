import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocalizationRepository {
  LocalizationRepository();

  Future<Position?> getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
