import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/currency.dart';
import 'package:book_my_weather/models/currency_rate.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:book_my_weather/services/setting.dart';
import 'package:book_my_weather/utilities/index.dart';

class CurrencyModel {
  Future<List<String>> getCurrencyCodes() async {
    NetworkHelper networkHelper = NetworkHelper(kCurrencyListURL);

    Map<String, dynamic> result = await networkHelper.getData();

    return (result['response']['currencies'] as List)
        .map((c) => c['code'] as String)
        .toList();
  }

  Future<Currency> getSingleCurrencyCode(double lat, double lng) async {
    final url = '$kOpenCaseAPIBaseURL$lat+$lng';
    NetworkHelper networkHelper = NetworkHelper(url);

    Map<String, dynamic> result = await networkHelper.getData();

    return Currency.fromJson(result);
  }

  Future<CurrencyRate> getCurrencyRate(String code) async {
    SettingModel settingModel = SettingModel();
    final currentSetting = settingModel.getCurrentSetting();

    final url = getCurrencyRateAPIURL(currentSetting.baseSymbol, code);
    NetworkHelper networkHelper = NetworkHelper(url);

    Map<String, dynamic> result = await networkHelper.getData();

    return CurrencyRate.fromJson(result, code);
  }
}
