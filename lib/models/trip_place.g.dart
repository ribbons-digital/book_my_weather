// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripPlace _$TripPlaceFromJson(Map<String, dynamic> json) {
  return TripPlace(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    rating: (json['rating'] as num)?.toDouble(),
    review: json['review'] as int,
    description: json['description'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String,
    websiteURL: json['websiteURL'] as String,
    photos: (json['photos'] as List)?.map((e) => e as String)?.toList(),
    businessHours:
        (json['businessHours'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$TripPlaceToJson(TripPlace instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'rating': instance.rating,
      'review': instance.review,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'websiteURL': instance.websiteURL,
      'photos': instance.photos,
      'businessHours': instance.businessHours,
    };
