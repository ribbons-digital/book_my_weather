class GooglePlaceDetail {
  final String address;
  final List<String> photos;
  final String phoneNumber;
  final List<String> openingHours;
  final String website;
  final String googleUrl;
  final String todayOpeningHour;

  GooglePlaceDetail({
    this.address,
    this.photos,
    this.phoneNumber,
    this.openingHours,
    this.website,
    this.googleUrl,
    this.todayOpeningHour,
  });

  factory GooglePlaceDetail.fromJson(Map<String, dynamic> result) {
    List<String> photos =
        result['photos'] != null && result['photos'].length > 0
            ? (result['photos'] as List)
                .map((photo) => photo['photo_reference'] as String)
                .toList()
            : [];

    List<String> openingHours = result['opening_hours'] != null &&
            result['opening_hours']['weekday_text'] != null
        ? (result['opening_hours']['weekday_text'] as List)
            .map((hour) => hour as String)
            .toList()
        : [];

    bool is24Hour = result['opening_hours'] != null &&
        result['opening_hours']['periods']
                .map((period) => period['open'])
                .toList()
                .length ==
            1 &&
        result['opening_hours']['periods']
                .map((period) => period['open'])
                .toList()[0]['day'] ==
            0 &&
        result['opening_hours']['periods']
                .map((period) => period['open'])
                .toList()[0]['time'] ==
            '0000';

    String todayOpeningHour = is24Hour
        ? '24 Hours'
        : result['opening_hours'] != null
            ? result['opening_hours']['periods']
                .map((period) => period['open'])
                .toList()
                .where(
                    (dayInWeek) => dayInWeek['day'] == DateTime.now().weekday)
                .toList()[0]['time']
            : '';

    return GooglePlaceDetail(
      address: result['formatted_address'],
      photos: photos,
      phoneNumber: result['formatted_phone_number'],
      website: result['website'],
      openingHours: openingHours,
      googleUrl: result['url'],
      todayOpeningHour: todayOpeningHour,
    );
  }
}
