import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Trip {
  final String id;
  final String createdByUid;
  String name;
  String destination;
  Timestamp startDate;
  Timestamp endDate;
  String description;
  GeoPoint location;
  List<String> heroImages;

  Trip({
    this.id,
    @required this.createdByUid,
    @required this.name,
    @required this.destination,
    @required this.startDate,
    @required this.endDate,
    @required this.location,
    this.description,
    this.heroImages,
  });

  factory Trip.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    List<String> heroImages = [];
    if (data['heroImages'].length > 0) {
      heroImages = (data['heroImages'] as List)
          .map((heroImage) => heroImage as String)
          .toList();
    }

    return Trip(
      id: doc.documentID,
      createdByUid: data['createdByUid'],
      name: data['name'],
      destination: data['destination'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      description: data['description'],
      location: data['location'],
      heroImages: heroImages,
    );
  }
}
