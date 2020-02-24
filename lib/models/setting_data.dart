import 'package:book_my_weather/models/setting.dart';
import 'package:flutter/foundation.dart';

class SettingData extends ChangeNotifier {
  Setting _setting = Setting(useCelsius: true);

  Setting get setting => _setting;

  void toggleTemperatureUnit() {
    _setting.useCelsius = !_setting.useCelsius;
    notifyListeners();
  }
}
