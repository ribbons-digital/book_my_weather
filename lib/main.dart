import 'package:book_my_weather/models/currentlyWeather.dart';
import 'package:book_my_weather/models/dailyWeather.dart';
import 'package:book_my_weather/models/dailyWeatherData.dart';
import 'package:book_my_weather/models/hourlyWeather.dart';
import 'package:book_my_weather/models/hourlyWeatherData.dart';
import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/user.dart';
import 'package:book_my_weather/models/weather.dart';
import 'package:book_my_weather/services/auth.dart';
import 'package:book_my_weather/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(SettingAdapter());
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(WeatherAdapter());
  Hive.registerAdapter(HourlyWeatherAdapter());
  Hive.registerAdapter(HourlyWeatherDataAdapter());
  Hive.registerAdapter(DailyWeatherAdapter());
  Hive.registerAdapter(DailyWeatherDataAdapter());
  Hive.registerAdapter(CurrentlyWeatherAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final auth = AuthService();
    return StreamProvider<User>.value(
      value: auth.user,
      child: Wrapper(isIos: isIos),
    );
  }
}
