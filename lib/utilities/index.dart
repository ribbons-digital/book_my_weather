import 'dart:convert';

import 'package:book_my_weather/secure/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
