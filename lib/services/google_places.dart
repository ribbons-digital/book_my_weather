import 'package:book_my_weather/constants.dart';
import 'package:book_my_weather/models/google_nearby_place.dart';
import 'package:book_my_weather/models/google_place_detail.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:flutter/cupertino.dart';

class GooglePlaces {
  Future<List<GoogleNearByPlace>> getNearbyShoppingPlaces({
    @required double latitude,
    @required double longitude,
  }) async {
    final requestUrl =
        '$kGPlaceNearbyShoppingSearchBaseURL&location=$latitude,$longitude';

    NetworkHelper networkHelper = NetworkHelper(requestUrl);

    Map<String, dynamic> data = await networkHelper.getData();

    List<GoogleNearByPlace> result = (data['results'] as List).map((result) {
      return GoogleNearByPlace.fromJson(result);
    }).toList();

    return result;
  }

  Future<List<GoogleNearByPlace>> getNearbyPlaces({
    @required double latitude,
    @required double longitude,
    @required String type,
  }) async {
    final requestUrl =
        '$kGPlaceNearbySearchBaseURL&location=$latitude,$longitude&type=$type';

    NetworkHelper networkHelper = NetworkHelper(requestUrl);

    Map<String, dynamic> data = await networkHelper.getData();

    List<GoogleNearByPlace> result = (data['results'] as List).map((result) {
      return GoogleNearByPlace.fromJson(result);
    }).toList();

    return result;
  }

  Future<GooglePlaceDetail> getPlaceDetail({@required String placeId}) async {
    final requestUrl = '$kGPlaceDetailBaseURL&place_id=$placeId';

    NetworkHelper networkHelper = NetworkHelper(requestUrl);

    Map<String, dynamic> data = await networkHelper.getData();

    GooglePlaceDetail result = GooglePlaceDetail.fromJson(data['result']);

    return result;
  }
}
