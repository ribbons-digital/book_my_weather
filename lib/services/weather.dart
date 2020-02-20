import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:flutter/cupertino.dart';

const darkSkyApiUrl = 'https://api.darksky.net/forecast';

enum RequestedWeatherType { Hourly, Daily, Both }

class WeatherModel {
//  Future<dynamic> getCityWeather(String cityName) async {
//    String url = '$darkSkyApiUrl?q=$cityName&appid=$apiKey&units=metric';
//    NetworkHelper networkHelper = NetworkHelper(url);
//
//    return await networkHelper.getData();
//  }

  Future<Weather> getLocationWeather({
    @required RequestedWeatherType type,
    double latitude,
    double longitude,
  }) async {
    String requestUrl;
    List<String> excludes = type == RequestedWeatherType.Hourly
        ? ["currently", "minutely", "daily", "alerts", "flags"]
        : type == RequestedWeatherType.Daily
            ? ["currently", "minutely", "hourly", "alerts", "flags"]
            : ["currently", "minutely", "alerts", "flags"];
    if (latitude != null && longitude != null) {
      requestUrl =
          '$darkSkyApiUrl/$kDarkSkyAPIKey/$latitude,$longitude?exclude=$excludes';
    } else {
      Location location = Location();
      await location.getLocation();
      requestUrl =
          '$darkSkyApiUrl/$kDarkSkyAPIKey/${location.latitude},${location.longitude}?exclude=$excludes';
    }

    NetworkHelper networkHelper = NetworkHelper(requestUrl);

    Map<String, dynamic> hourlyWeatherMap = await networkHelper.getData();
//

    return Weather.fromJson(hourlyWeatherMap);
  }

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
