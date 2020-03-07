import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PlaceCard extends StatelessWidget {
//  final String currentTemp;
//  final String currentWeatherIconPath;
  final String placeImgPath;
  final String placeName;
  final String placeCategory;
  final double placeRating;
  final String placeReview;
//  final String placeDesc;
//  final String placeOpenHour;
  final bool isExplore;
  final bool openNow;
  final String placeId;

  PlaceCard({
//    @required this.currentTemp,
//    @required this.currentWeatherIconPath,
    @required this.placeImgPath,
    @required this.placeName,
    @required this.placeCategory,
    @required this.placeRating,
//    @required this.placeDesc,
//    @required this.placeOpenHour,
    @required this.isExplore,
    @required this.placeReview,
    this.openNow,
    this.placeId,
  });

  Column _buildBottomSheetMenu(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: SvgPicture.asset(
            'assets/images/note_solid.svg',
            width: 14.0,
            height: 16.0,
            color: Color(0XFF69A4FF),
          ),
          title: Text(
            'Add note',
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF69A4FF),
            ),
          ),
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/images/share_solid.svg',
            width: 14.0,
            height: 16.0,
            color: Color(0XFF69A4FF),
          ),
          title: Text(
            'Share',
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF69A4FF),
            ),
          ),
          onTap: () async {
            final url =
                'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=url&place_id=$placeId';
            NetworkHelper networkHelper = NetworkHelper(url);

            try {
              Map<String, dynamic> result = await networkHelper.getData();
              Share.share(result['result']['url']);
              Navigator.pop(context);
            } catch (e) {
              print(e.toString());
            }
          },
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/images/map_solid.svg',
            width: 14.0,
            height: 16.0,
            color: Color(0XFF69A4FF),
          ),
          title: Text(
            'Direction',
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF69A4FF),
            ),
          ),
          onTap: () async {
            final url =
                'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=formatted_address&place_id=$placeId';
//                            http.Response response = await http.get(url);
            NetworkHelper networkHelper = NetworkHelper(url);

            try {
              Map<String, dynamic> result = await networkHelper.getData();
              final address = result['result']['formatted_address'];
              MapsLauncher.launchQuery(address);
              Navigator.pop(context);
            } catch (e) {
              print(e.toString());
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.all(16.0),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: 0.5,
              widthFactor: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: placeImgPath.contains('https')
                    ? Image.network(
                        placeImgPath,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        placeImgPath,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(placeName),
                    subtitle: Text(placeCategory.split('_').join(' ')),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 200,
                                child: _buildBottomSheetMenu(context),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
//                                    borderRadius: BorderRadius.only(
//                                      topRight: const Radius.circular(10),
//                                      topLeft: const Radius.circular(10),
//                                    ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          placeRating.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        SmoothStarRating(
                          allowHalfRating: true,
                          onRatingChanged: (v) {
//                              rating = v;
//                              setState(() {});
                          },
                          starCount: 5,
                          rating: placeRating,
                          size: 18.0,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Color(0XFF69A4FF),
                          borderColor: Color(0XFF69A4FF),
                          spacing: 0.0,
                        ),
                        Text(
                          placeReview,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(
//                      left: 15.0,
//                      top: 10.0,
//                      bottom: 8.0,
//                      right: 15.0,
//                    ),
//                    child: Text(
//                      placeDesc,
//                      style: TextStyle(
//                        fontSize: 16.0,
//                      ),
//                      maxLines: 3,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                  ),
                  if (openNow != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: openNow ? 'Open now' : 'Closed',
                              style: TextStyle(
                                color: openNow ? Colors.green : Colors.red,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
//                  Container(
//                    width: double.infinity,
//                    height: 40.0,
//                    padding: EdgeInsets.only(left: 15.0),
//                    child: ListView(
//                      scrollDirection: Axis.horizontal,
//                      children: <Widget>[
//                        FlatButton(
//                          shape: RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.circular(18.0),
//                            side: BorderSide(
//                              color: Color(0XFF69A4FF),
//                            ),
//                          ),
//                          child: Row(
//                            children: <Widget>[
//                              SvgPicture.asset(
//                                'assets/images/note_solid.svg',
//                                width: 14.0,
//                                height: 16.0,
//                                color: Color(0XFF69A4FF),
//                              ),
//                              SizedBox(
//                                width: 5.0,
//                              ),
//                              Text(
//                                'Add note',
//                                style: TextStyle(
//                                  color: Color(0XFF69A4FF),
//                                ),
//                              ),
//                            ],
//                          ),
//                          onPressed: () {},
//                        ),
//                        SizedBox(
//                          width: 20.0,
//                        ),
//                        FlatButton(
//                          child: Row(
//                            children: <Widget>[
//                              SvgPicture.asset(
//                                'assets/images/share_solid.svg',
//                                width: 14.0,
//                                height: 16.0,
//                                color: Color(0XFF69A4FF),
//                              ),
//                              SizedBox(
//                                width: 5.0,
//                              ),
//                              Text(
//                                'Share',
//                                style: TextStyle(
//                                  color: Color(0XFF69A4FF),
//                                ),
//                              ),
//                            ],
//                          ),
//                          shape: RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.circular(18.0),
//                            side: BorderSide(
//                              color: Color(0XFF69A4FF),
//                            ),
//                          ),
//                          onPressed: () async {
//                            final url =
//                                'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=url&place_id=$placeId';
////                            http.Response response = await http.get(url);
//                            NetworkHelper networkHelper = NetworkHelper(url);
//
//                            try {
//                              Map<String, dynamic> result =
//                                  await networkHelper.getData();
//                              Share.share(result['result']['url']);
//                            } catch (e) {
//                              print(e.toString());
//                            }
//                          },
//                        ),
//                        SizedBox(
//                          width: 20.0,
//                        ),
//                        FlatButton(
//                          child: Row(
//                            children: <Widget>[
//                              SvgPicture.asset(
//                                'assets/images/map_solid.svg',
//                                width: 15.0,
//                                height: 15.0,
//                                color: Color(0XFF69A4FF),
//                              ),
//                              SizedBox(
//                                width: 5.0,
//                              ),
//                              Text(
//                                'Direction',
//                                style: TextStyle(
//                                  color: Color(0XFF69A4FF),
//                                ),
//                              ),
//                            ],
//                          ),
//                          shape: RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.circular(18.0),
//                            side: BorderSide(
//                              color: Color(0XFF69A4FF),
//                            ),
//                          ),
//                          onPressed: () async {
//                            final url =
//                                'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=formatted_address&place_id=$placeId';
////                            http.Response response = await http.get(url);
//                            NetworkHelper networkHelper = NetworkHelper(url);
//
//                            try {
//                              Map<String, dynamic> result =
//                                  await networkHelper.getData();
//                              final address =
//                                  result['result']['formatted_address'];
//                              MapsLauncher.launchQuery(address);
//                            } catch (e) {
//                              print(e.toString());
//                            }
//                          },
//                        ),
//                      ],
//                    ),
//                  ),
                ],
              ),
            ),
          ),
          if (!isExplore)
            Align(
              alignment: Alignment(0.9, -0.9),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color(0x42000000),
                ),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
        ],
      ),
    );
  }
}
