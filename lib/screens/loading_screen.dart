import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../screens//location_screen.dart';
import '../services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  // Funcție care obține datele meteo bazate pe locația dispozitivului
  void getLocationData() async {
    var weatherData = await WeatherModel().getLocationWeather();

    // După ce datele sunt obținute, este afișat ecranul principal (LocationScreen)
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        locationWeather: weatherData, // Datele sunt trimise către noul ecran
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SpinKitWave(
      color: Colors.pink.shade200,
      size: 100.0,
    ));
  }
}
