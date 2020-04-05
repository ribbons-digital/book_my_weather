import 'dart:convert';

import 'package:book_my_weather/app_localizations.dart';
import 'package:book_my_weather/models/place.dart';
import 'package:book_my_weather/models/setting.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share/share.dart';

import '../constants.dart';

String timeStampToDateString(Timestamp timestamp) {
  return DateFormat('yMMMMd').format(timestamp.toDate());
}

String timeStampToISOString(Timestamp timestamp) {
  return timestamp.toDate().toIso8601String();
}

Future<List<String>> gPlaceAutoCompleteResult(String input) async {
  if (input.length > 0) {
    String gPlaceAutoCompleteURL = kGPlaceAutoCompleteURL;
    String type = '(regions)';
    String request =
        '$gPlaceAutoCompleteURL?input=$input&key=$kGooglePlacesAPIKey&type=$type';
    http.Response response = await http.get(request);
    List<String> placesResult = [];
    if (response.statusCode == 200) {
      final predictions = jsonDecode(response.body)['predictions'];
      for (var i = 0; i < predictions.length; i++) {
        placesResult.add(predictions[i]['description']);
      }
    }
    return placesResult;
  }
  return [''];
}

String buildPhotoURL(String photoReference) {
  return '$kGPlacePhotoSearchURL?maxwidth=800&photoreference=$photoReference&key=$kGooglePlacesAPIKey';
}

enum NearbySearchType {
  AmusementPark,
  ArtGallery,
  ATM,
  Bakery,
  Bank,
  Bar,
  BookStore,
  BusStation,
  Cafe,
  CarRepair,
  GasStation,
  SuperMarket,
  Laundry,
  Lodging,
  LiquorStore,
  Museum,
  NightClub,
  Park,
  Parking,
  Pharmacy,
  Store,
  TrainStation,
  ShoppingMall,
  Restaurant,
  TransitStation,
  SubwayStation,
}

String getSearchTypeString(NearbySearchType searchType) {
  if (searchType == NearbySearchType.AmusementPark) return 'amusement_park';
  if (searchType == NearbySearchType.ArtGallery) return 'art_gallery';
  if (searchType == NearbySearchType.ATM) return 'atm';
  if (searchType == NearbySearchType.Bakery) return 'bakery';
  if (searchType == NearbySearchType.Bank) return 'bank';
  if (searchType == NearbySearchType.Bar) return 'bar';
  if (searchType == NearbySearchType.BookStore) return 'book_store';
  if (searchType == NearbySearchType.Cafe) return 'cafe';
  if (searchType == NearbySearchType.CarRepair) return 'car_repair';
  if (searchType == NearbySearchType.BusStation) return 'bus_station';
  if (searchType == NearbySearchType.GasStation) return 'gas_station';
  if (searchType == NearbySearchType.Laundry) return 'laundry';
  if (searchType == NearbySearchType.Lodging) return 'lodging';
  if (searchType == NearbySearchType.LiquorStore) return 'liquor_store';
  if (searchType == NearbySearchType.Museum) return 'museum';
  if (searchType == NearbySearchType.NightClub) return 'night_club';
  if (searchType == NearbySearchType.Park) return 'park';
  if (searchType == NearbySearchType.Parking) return 'parking';
  if (searchType == NearbySearchType.Pharmacy) return 'pharmacy';
  if (searchType == NearbySearchType.Restaurant) return 'restaurant';
  if (searchType == NearbySearchType.ShoppingMall) return 'shopping_mall';
  if (searchType == NearbySearchType.Store) return 'store';
  if (searchType == NearbySearchType.SuperMarket) return 'supermarket';
  if (searchType == NearbySearchType.TrainStation) return 'train_station';
  if (searchType == NearbySearchType.TransitStation) return 'transit_station';
  if (searchType == NearbySearchType.SubwayStation) return 'subway_station';
  return 'shopping_mall';
}

String getSearchTypeStringWithLocalization(
    BuildContext context, NearbySearchType searchType) {
  if (searchType == NearbySearchType.ShoppingMall)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_1_string');
  if (searchType == NearbySearchType.ArtGallery)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_2_string');
  if (searchType == NearbySearchType.ATM)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_3_string');
  if (searchType == NearbySearchType.Bakery)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_4_string');
  if (searchType == NearbySearchType.Bank)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_5_string');
  if (searchType == NearbySearchType.Bar)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_6_string');
  if (searchType == NearbySearchType.BookStore)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_7_string');
  if (searchType == NearbySearchType.Park)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_8_string');
  if (searchType == NearbySearchType.Parking)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_9_string');
  if (searchType == NearbySearchType.TrainStation)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_10_string');
  if (searchType == NearbySearchType.SubwayStation)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_11_string');
  if (searchType == NearbySearchType.BusStation)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_12_string');
  if (searchType == NearbySearchType.GasStation)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_places_filter_label_13_string');
  if (searchType == NearbySearchType.Restaurant)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_foods_filter_label_1_string');
  if (searchType == NearbySearchType.Cafe)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_foods_filter_label_2_string');
  if (searchType == NearbySearchType.Lodging)
    return AppLocalizations.of(context)
        .translate('places_screen_nearby_hotel_filter_label_string');
  return '';
}

NearbySearchType searchType(String typeString) {
  if (typeString == 'shopping_mall') return NearbySearchType.ShoppingMall;
  if (typeString == 'art_gallery') return NearbySearchType.ArtGallery;
  if (typeString == 'atm') return NearbySearchType.ATM;
  if (typeString == 'bakery') return NearbySearchType.Bakery;
  if (typeString == 'bank') return NearbySearchType.Bank;
  if (typeString == 'bar') return NearbySearchType.Bar;
  if (typeString == 'book_store') return NearbySearchType.BookStore;
  if (typeString == 'cafe') return NearbySearchType.Cafe;
  if (typeString == 'restaurant') return NearbySearchType.Restaurant;
  if (typeString == 'park') return NearbySearchType.Park;
  if (typeString == 'parking') return NearbySearchType.Parking;
  if (typeString == 'train_station') return NearbySearchType.TrainStation;
  if (typeString == 'subway_station') return NearbySearchType.SubwayStation;
  if (typeString == 'bus_station') return NearbySearchType.BusStation;
  if (typeString == 'gas_station') return NearbySearchType.GasStation;
  if (typeString == 'lodging') return NearbySearchType.Lodging;

  return null;
}

String getTripTimeMessage(BuildContext context, Trip trip) {
  String timeMessage = '';

  final startDateISOString = timeStampToISOString(trip.startDate);
//
  final endDateISOString = timeStampToISOString(trip.endDate);
  final isPast = trip.endDateInMs < DateTime.now().millisecondsSinceEpoch;
  int daysLeft =
      DateTime.parse(startDateISOString).difference(DateTime.now()).inDays;

  int endedDaysAgo =
      DateTime.parse(endDateISOString).difference(DateTime.now()).inDays;

  if (daysLeft.isNegative && !isPast) {
    timeMessage =
        ' Started ${daysLeft.toString().substring(1, daysLeft.toString().length)} days ago';
  }
//
  if (daysLeft.isNegative && isPast) {
    if (endedDaysAgo < 0)
      timeMessage =
          ' Ended ${endedDaysAgo.toString().substring(1, endedDaysAgo.toString().length)} days ago';
    else
      timeMessage = ' Trip ends today';
  }
//
  if (!daysLeft.isNegative && !isPast) {
    if (daysLeft > 1)
      timeMessage = ' $daysLeft days, from today';
    else
      timeMessage = ' $daysLeft day, from today';
  }

  if (daysLeft == 0) {
    timeMessage = ' Trip starts today';
  }

  return timeMessage;
}

void displayErrorSnackbar(BuildContext context, String errorMsg) {
  Flushbar(
    messageText: Text(
      errorMsg,
      style: kSnackbarErrorTextStyle,
    ),
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.warning,
      size: 20.0,
      color: Colors.red,
    ),
  )..show(context);
}

void displayErrorSnackbarWithSilentAction(
    BuildContext context, String errorMsg, Function fn) {
  Flushbar(
    messageText: Text(
      errorMsg,
      style: kSnackbarErrorTextStyle,
    ),
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.warning,
      size: 20.0,
      color: Colors.red,
    ),
  )..show(context).then(fn);
}

void displayErrorSnackbarWithAction({
  BuildContext context,
  String msg,
  Function actionFn,
  String buttonText,
}) {
  Flushbar(
    messageText: Text(
      msg,
      style: kSnackbarErrorTextStyle,
    ),
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.warning,
      size: 20.0,
      color: Colors.red,
    ),
    mainButton: FlatButton(
      onPressed: actionFn,
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  )..show(context);
}

void displaySuccessSnackbar(BuildContext context, String msg) {
  Flushbar(
    messageText: Text(
      msg,
      style: kSnackbarSuccessTextStyle,
    ),
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.check_box,
      size: 20.0,
      color: Colors.green,
    ),
  )..show(context);
}

void displaySuccessSnackbarWithAction(
    {BuildContext context, String msg, Function actionFn, String buttonText}) {
  Flushbar(
    messageText: Text(
      msg,
      style: kSnackbarSuccessTextStyle,
    ),
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.check_box,
      size: 20.0,
      color: Colors.green,
    ),
    mainButton: FlatButton(
      onPressed: actionFn,
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  )..show(context);
}

void initializeSetting(Setting newSetting) {
  final settingsBox = Hive.box('settings');
  settingsBox.add(newSetting);
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

String getCurrencySymbol(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  final format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.currencyName; // USD
}

String getCurrencyRateAPIURL(String base, String symbol) {
  return 'https://api.ratesapi.io/api/latest?base=$base&symbols=$symbol';
}

void getPlaceDirection(BuildContext context, String placeId) async {
  final url =
      'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=formatted_address&place_id=$placeId';
  NetworkHelper networkHelper = NetworkHelper(url);

  try {
    Map<String, dynamic> result = await networkHelper.getData();
    final address = result['result']['formatted_address'];
    MapsLauncher.launchQuery(address);
    Navigator.pop(context);
  } catch (e) {
    Navigator.pop(context);
    displayErrorSnackbar(context, 'Something wrong, please try again later.');
  }
}

void sharePlace(BuildContext context, String placeId) async {
  final url =
      'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=url&place_id=$placeId';
  NetworkHelper networkHelper = NetworkHelper(url);

  try {
    Map<String, dynamic> result = await networkHelper.getData();
    Share.share(result['result']['url']);
    Navigator.pop(context);
  } catch (e) {
    Navigator.pop(context);
    displayErrorSnackbar(context, 'Something wrong, please try again later.');
  }
}
