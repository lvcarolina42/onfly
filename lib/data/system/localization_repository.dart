import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';

class LocalizationRepository {
  LocalizationRepository();

  Future<Position?> getPosition() async {
    bool serviceStatus = await Geolocator.isLocationServiceEnabled();

    if(serviceStatus){
      print("GPS service is enabled");
    }else{
      print("GPS service is disabled.");
    }

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
