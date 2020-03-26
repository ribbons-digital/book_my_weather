import 'package:book_my_weather/models/place.dart';
import 'package:hive/hive.dart';

part 'setting.g.dart';

@HiveType(typeId: 0)
class Setting {
//  final String id;
  @HiveField(0)
  bool useCelsius;
  @HiveField(1)
  List<Place> places;
  @HiveField(2)
  String baseSymbol;

  Setting({this.useCelsius, this.places, this.baseSymbol});

//  factory Setting.fromFirestore(DocumentSnapshot doc) {
//    Map data = doc.data;
//
//    List<Place> places = [];
//    if (data['places'] != null) {
//      places = (data['places'] as List)
//          .map((place) => Place.fromJson(place))
//          .toList();
//    }
//
//    return Setting(
//      id: doc.documentID,
//      useCelsius: data['useCelsius'] ?? true,
//      places: places,
//    );
//  }
}
