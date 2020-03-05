import 'package:book_my_weather/secure/keys.dart';
import 'package:flutter/material.dart';

const kTextFieldStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w100,
  fontSize: 24.0,
);

const kDateTextStyle = TextStyle(
  fontWeight: FontWeight.w100,
  fontSize: 20,
  color: Colors.white,
);

const kTempRangeTextStyle = TextStyle(
  fontWeight: FontWeight.w100,
  fontSize: 20,
  color: Colors.white,
);

const kGPlaceAutoCompleteURL =
    'https://maps.googleapis.com/maps/api/place/autocomplete/json';

const kGPlaceSearchURL =
    'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=photos';

const kGPlaceNearbySearchBaseURL =
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$kGooglePlacesAPIKey&radius=5000';

const kGPlacePhotoSearchURL =
    'https://maps.googleapis.com/maps/api/place/photo';

const kUnsplashAPIURL =
    'https://api.unsplash.com/photos/random?count=1&client_id=$kUnsplashAPIKey';

const kAqiCNAPIBaseURL = 'https://api.waqi.info/feed/geo:';
