import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:hive/hive.dart';

class SettingModel {
  void initializeSetting(Setting newSetting) {
    final settingsBox = Hive.box('settings');
    settingsBox.add(newSetting);
  }

  Setting getCurrentSetting() {
    final settingsBox = Hive.box('settings');
    if (settingsBox.length > 0) {
      return settingsBox.getAt(0) as Setting;
    }
    return null;
  }

  void addPlaceToSetting(Place newPlace) {
    final settingsBox = Hive.box('settings');
    Setting setting = settingsBox.getAt(0) as Setting;
    List<Place> places = (settingsBox.get(0) as Setting).places;
    places.add(newPlace);
    setting = Setting(
      useCelsius: setting.useCelsius,
      places: places,
      baseSymbol: setting.baseSymbol,
    );

    settingsBox.putAt(0, setting);
  }

  void updatePlaceInSetting(int index, Place updatedPlace) {
    final settingsBox = Hive.box('settings');
    Setting setting = settingsBox.getAt(0) as Setting;
    List<Place> places = (settingsBox.get(0) as Setting).places;
    places[index] = updatedPlace;
    setting = Setting(
      useCelsius: setting.useCelsius,
      places: places,
      baseSymbol: setting.baseSymbol,
    );

    settingsBox.putAt(0, setting);
  }

  void updateTempUnitInSetting(bool useCelsius) {
    final settingsBox = Hive.box('settings');
    Setting setting = settingsBox.getAt(0) as Setting;
    setting = Setting(
      useCelsius: useCelsius,
      places: setting.places,
      baseSymbol: setting.baseSymbol,
    );

    settingsBox.putAt(0, setting);
  }

  void updateBaseCurrencyInSetting(String base) {
    final settingsBox = Hive.box('settings');
    Setting setting = settingsBox.getAt(0) as Setting;

    setting = Setting(
      useCelsius: setting.useCelsius,
      places: setting.places,
      baseSymbol: base,
    );

    settingsBox.putAt(0, setting);
  }

  void clearPlacesWeatherDataInSetting() {
    final settingsBox = Hive.box('settings');
    Setting setting = settingsBox.getAt(0) as Setting;

    setting = Setting(
      useCelsius: setting.useCelsius,
      places: [setting.places[0]],
      baseSymbol: setting.baseSymbol,
    );

    settingsBox.putAt(0, setting);
  }
}
