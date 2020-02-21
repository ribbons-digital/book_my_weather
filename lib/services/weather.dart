import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/location.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:flutter/cupertino.dart';

const darkSkyApiUrl = 'https://api.darksky.net/forecast';

enum RequestedWeatherType { Hourly, Daily, Both }

class WeatherModel {
  Future<Weather> getLocationWeather({
    @required RequestedWeatherType type,
    @required bool useCelsius,
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
      requestUrl = useCelsius
          ? '$darkSkyApiUrl/$kDarkSkyAPIKey/$latitude,$longitude?units=si&?exclude=$excludes'
          : '$darkSkyApiUrl/$kDarkSkyAPIKey/$latitude,$longitude?exclude=$excludes';
    } else {
      Location location = Location();
      await location.getLocation();
      requestUrl = useCelsius
          ? '$darkSkyApiUrl/$kDarkSkyAPIKey/${location.latitude},${location.longitude}?units=si&?exclude=$excludes'
          : '$darkSkyApiUrl/$kDarkSkyAPIKey/${location.latitude},${location.longitude}?exclude=$excludes';
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
