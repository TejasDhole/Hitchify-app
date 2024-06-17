import 'package:geolocator/geolocator.dart';

class LocationCache {
  static final LocationCache _instance = LocationCache._internal();
  Position? currentPosition;

  factory LocationCache() {
    return _instance;
  }

  LocationCache._internal();
}
