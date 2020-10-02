import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Location {
  double latitude;
  double longitude;

  Future<List> getCurrentLocation() async {
    List<String> locationData = [];
    try {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      // print(placemarks);
      locationData.add(placemarks[2].locality);
      locationData.add(placemarks[2].administrativeArea);
      // print(locationData);
    } catch (e) {
      print(e);
    }
    // print(city);
    return locationData;
  }
}
