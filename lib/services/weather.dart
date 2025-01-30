import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

// Constante pentru cheia API și URL-ul OpenWeatherMap
const apiKey = '37999de367e97507ab9a7bae6fc85d5f';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  // Metodă pentru obținerea vremii unui oraș introdus de utilizator
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  // Metodă pentru obținerea vremii bazate pe locația curentă a utilizatorului
  Future<dynamic> getLocationWeather() async {
    // Obtine locatia curenta
    Location location = Location();
    await location.getCurrentLocation();

    // Construiește cererea către API folosind latitudinea și longitudinea obținute
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    // Face cererea către API și returnează datele primite
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  // Metodă care returnează un emoji în funcție de condiția meteo
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  // Metodă care returnează o imagine în funcție de condiția meteo
  String getWeatherImage(int condition) {
    if (condition < 300) {
      return 'thunder.jpg';
    } else if (condition < 400) {
      return 'snowing.png';
    } else if (condition < 600) {
      return 'rain.jpg';
    } else if (condition < 700) {
      return 'snow.jpg';
    } else if (condition < 800) {
      return 'wind.jpg';
    } else if (condition == 800) {
      return 'sun.jpg';
    } else if (condition <= 804) {
      return 'location_background.jpg';
    } else {
      return '🤷‍';
    }
  }

  // Metodă care returnează un mesaj personalizat în funcție de temperatura curentă
  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
