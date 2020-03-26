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
  String temperature;
  String weatherIcon;
  List<String> searchIndex;
  int endDateInMs;
  double currencyRate;
  String currencyCode;

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
    this.temperature,
    this.weatherIcon,
    this.searchIndex,
    this.endDateInMs,
    this.currencyRate,
    this.currencyCode,
  });

  factory Trip.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    List<String> heroImages = [];
    List<String> searchIndex = [];

    if (data['heroImages'].length > 0) {
      heroImages = (data['heroImages'] as List)
          .map((heroImage) => heroImage as String)
          .toList();
    }

    if (data['searchIndex'].length > 0) {
      searchIndex = (data['searchIndex'] as List)
          .map((indexString) => indexString as String)
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
      temperature: data['temperature'],
      weatherIcon: data['weatherIcon'],
      searchIndex: searchIndex,
      endDateInMs: data['endDateInMs'],
      currencyRate: data['currencyRate'],
      currencyCode: data['currencyCode'],
    );
  }
}
