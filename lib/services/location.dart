import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    // Setări pentru obținerea locației cu acuratețe scăzută și actualizări la fiecare 100 de metri
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 100,
    );

    // Verifică dacă serviciile de locație sunt activate pe dispozitiv
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Verifică permisiunile de locație ale aplicației
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print('Requesting location permission...');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('User denied location permission.');
        return;
      }
    }

    // Dacă permisiunea este refuzată permanent, nu se poate continua
    if (permission == LocationPermission.deniedForever) {
      print('Location permission is permanently denied.');
      return;
    }

    // Obține poziția curentă a dispozitivului cu setările specificate
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
      forceAndroidLocationManager: true,
    );
    print(position);

    // Stochează latitudinea și longitudinea obținute
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
