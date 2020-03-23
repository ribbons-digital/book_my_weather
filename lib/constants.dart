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

const kSnackbarErrorTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 18.0,
  fontWeight: FontWeight.w300,
);

const kSnackbarSuccessTextStyle = TextStyle(
  color: Colors.green,
  fontSize: 18.0,
  fontWeight: FontWeight.w300,
);

const kGPlaceAutoCompleteURL =
    'https://maps.googleapis.com/maps/api/place/autocomplete/json';

const kGPlaceSearchURL =
    'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=photos';

const kGPlaceNearbyShoppingSearchBaseURL =
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$kGooglePlacesAPIKey&radius=5000&type=shopping_mall';

const kGPlaceNearbySearchBaseURL =
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$kGooglePlacesAPIKey&radius=5000';

const kGPlacePhotoSearchURL =
    'https://maps.googleapis.com/maps/api/place/photo';

const kUnsplashAPIURL =
    'https://api.unsplash.com/photos/random?count=1&client_id=$kUnsplashAPIKey';

const kAqiCNAPIBaseURL = 'https://api.waqi.info/feed/geo:';

const kGPlaceDetailBaseURL =
    'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=url,formatted_address,photos,formatted_phone_number,opening_hours/weekday_text,opening_hours/periods,website';

const kGuardianNewsAPIBaseURL =
    'https://content.guardianapis.com/search?api-key=$kGuardianNewsAPIKey&page-size=20&q=';

const kClearDay = 'clear-day';
const kClearNight = 'clear-night';
const kRain = 'rain';
const kSnow = 'snow';
const kSleet = 'sleet';
const kWind = 'wind';
const kFog = 'fog';
const kCloudy = 'cloudy';
const kPartlyCloudyDay = 'partly-cloudy-day';
const kPartlyCloudyNight = 'partly-cloudy-night';
