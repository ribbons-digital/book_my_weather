class GooglePlaceDetail {
  final String address;
  final List<String> photos;
  final String phoneNumber;
  final List<String> openingHours;
  final String website;
  final String googleUrl;

  GooglePlaceDetail({
    this.address,
    this.photos,
    this.phoneNumber,
    this.openingHours,
    this.website,
    this.googleUrl,
  });

  factory GooglePlaceDetail.fromJson(Map<String, dynamic> result) {
    List<String> photos =
        result['photos'] != null && result['photos'].length > 0
            ? (result['photos'] as List)
                .map((photo) => photo['photo_reference'] as String)
                .toList()
            : [];

    List<String> openingHours =
        (result['opening_hours']['weekday_text'] as List)
            .map((hour) => hour as String)
            .toList();

    return GooglePlaceDetail(
      address: result['formatted_address'],
      photos: photos,
      phoneNumber: result['formatted_phone_number'],
      website: result['website'],
      openingHours: openingHours,
      googleUrl: result['url'],
    );
  }
}
