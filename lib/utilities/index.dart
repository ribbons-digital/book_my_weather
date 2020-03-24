import 'dart:convert';

import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  Meseum,
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
  if (searchType == NearbySearchType.Meseum) return 'museum';
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

String getTripTimeMessage(BuildContext context, Trip trip) {
  String timeMessage = '';
  final trips = Provider.of<List<Trip>>(context);

  final startDateISOString = timeStampToISOString(trip.startDate);

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

  if (daysLeft.isNegative && isPast) {
    timeMessage =
        ' Ended ${endedDaysAgo.toString().substring(1, daysLeft.toString().length)} days ago';
  }

  if (!daysLeft.isNegative && !isPast) {
    timeMessage = ' $daysLeft days, from today';
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
