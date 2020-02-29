import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip_place.g.dart';

@JsonSerializable(explicitToJson: true)
class TripPlace {
  final String id;
//  final List<String> trips;
  final String name;
  final String category;
  final double rating;
  final int review;
  final String description;
//  final bool isClosed;
//  final String todayOpenHour;
  final String address;
  final String phone;
  final String websiteURL;
  final List<String> photos;
//  final String note;
  final List<String> businessHours;

  TripPlace({
    this.id,
//    this.trips,
    this.name,
    this.category,
    this.rating,
    this.review,
    this.description,
//    this.isClosed,
//    this.todayOpenHour,
    this.address,
    this.phone,
    this.websiteURL,
    this.photos,
//    this.note,
    this.businessHours,
  });

  factory TripPlace.fromJson(Map<String, dynamic> json) =>
      _$TripPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$TripPlaceToJson(this);

  factory TripPlace.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return TripPlace(
      id: doc.documentID,
//      trips: data['trips'],
      name: data['name'],
      category: data['category'],
      rating: data['rating'],
      review: data['review'],
      description: data['description'],
//      isClosed: data['isClosed'],
//      todayOpenHour: data['todayOpenHour'],
      address: data['address'],
      phone: data['phone'],
      websiteURL: data['websiteURL'],
      photos: data['photos'],
//      note: data['note'],
      businessHours: data['businessHours'],
    );
  }
}
