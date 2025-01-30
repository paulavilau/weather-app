import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int temp = 10;
  String? cityName;
  String weatherIcon = '☀️';
  String message = 'It\'s 🍦 time';
  String weatherImage = 'location_background.jpg';

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  // Funcție care actualizează UI-ul în funcție de datele meteo
  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temp = 0;
        weatherIcon = 'Error';
        message = 'Unable to get weather data';
        cityName = '';
        weatherImage = 'location_background.jpg';
        return;
      }
      var condNumber = weatherData['weather'][0]['id'];
      double tempDouble = weatherData['main']['temp'];
      temp = tempDouble.toInt();
      cityName = weatherData['name'];

      print(cityName);

      weatherIcon = weatherModel.getWeatherIcon(condNumber);
      message = weatherModel.getMessage(temp);
      weatherImage = weatherModel.getWeatherImage(condNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/$weatherImage'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        var weatherData =
                            await weatherModel.getLocationWeather();
                        print(weatherData);
                        updateUI(weatherData);
                      },
                      child:
                          Icon(Icons.near_me, size: 50.0, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CityScreen();
                            },
                          ),
                        );
                        if (typedName != null) {
                          print(typedName);
                          var weatherData =
                              await weatherModel.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                      },
                      child: Icon(Icons.location_city,
                          size: 50.0, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        backgroundColor:
                            Colors.redAccent, // 🔴 Logout button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(
                            15, 15), // 👌 Ensures only necessary space is used
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // 🏆 Shrinks button size
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // ✅ Ensures no extra space
                        children: [
                          Icon(Icons.exit_to_app,
                              color: Colors.white, size: 20), // 🚪 Icon
                          SizedBox(
                              width: 6), // Small space between icon and text
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0, bottom: 40),
                child: Text(
                  '$message in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
