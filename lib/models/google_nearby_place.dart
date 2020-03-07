class GoogleNearByPlace {
  final String name;
  final String placeId;
  final List<String> photos;
  final double latitude;
  final double longitude;
  final List<String> types;
  final bool openNow;
  final double rating;
  final int ratingTotals;
  final String address;

  GoogleNearByPlace({
    this.name,
    this.placeId,
    this.photos,
    this.latitude,
    this.longitude,
    this.types,
    this.openNow,
    this.rating,
    this.ratingTotals,
    this.address,
  });

  factory GoogleNearByPlace.fromJson(Map<String, dynamic> result) {
    List<String> photos =
        result['photos'] != null && result['photos'].length > 0
            ? (result['photos'] as List)
                .map((photo) => photo['photo_reference'] as String)
                .toList()
            : [];

    List<String> types =
        (result['types'] as List).map((type) => type as String).toList();

    return result['opening_hours'] == null
        ? GoogleNearByPlace(
            name: result['name'],
            placeId: result['place_id'],
            photos: photos,
            latitude: result['geometry']['location']['lat'],
            longitude: result['geometry']['location']['lng'],
            types: types,
            rating: result['rating'] == null
                ? 0
                : result['rating'] is int
                    ? (result['rating'] as int).toDouble()
                    : result['rating'],
            ratingTotals: result['user_ratings_total'],
            address: result['vicinity'],
          )
        : GoogleNearByPlace(
            name: result['name'],
            placeId: result['place_id'],
            photos: photos,
            latitude: result['geometry']['location']['lat'],
            longitude: result['geometry']['location']['lng'],
            types: types,
            openNow: result['opening_hours']['open_now'],
            rating: result['rating'] == null
                ? 0
                : result['rating'] is int
                    ? (result['rating'] as int).toDouble()
                    : result['rating'],
            ratingTotals: result['user_ratings_total'],
            address: result['vicinity'],
          );
  }
}
