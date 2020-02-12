import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PlaceCard extends StatelessWidget {
  final String currentTemp;
  final String currentWeatherIconPath;
  final String placeImgPath;
  final String placeName;
  final String placeCategory;
  final String placeRating;
  final String placeReview;
  final String placeDesc;
  final String placeOpenHour;

  PlaceCard({
    @required this.currentTemp,
    @required this.currentWeatherIconPath,
    @required this.placeImgPath,
    @required this.placeName,
    @required this.placeCategory,
    @required this.placeRating,
    @required this.placeDesc,
    @required this.placeOpenHour,
    @required this.placeReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.all(16.0),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0.9, -0.15),
            child: FlatButton(
              child: Text(
                'Forecast detail',
                style: TextStyle(
                  color: Color(0XFF69A4FF),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(
                  color: Color(0XFF69A4FF),
                ),
              ),
              onPressed: () {},
            ),
          ),
          Align(
            widthFactor: 0.92,
            alignment: Alignment(0.8, -0.33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SvgPicture.asset(currentWeatherIconPath,
                    color: Colors.black, semanticsLabel: 'sunny-line'),
                Text(currentTemp + 'º currently'),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: 0.3,
              widthFactor: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Image.asset(
                  placeImgPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: FractionallySizedBox(
              heightFactor: 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(placeName),
                    subtitle: Text(placeCategory),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          placeRating,
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
                          rating: 4.3,
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      top: 10.0,
                      bottom: 8.0,
                      right: 15.0,
                    ),
                    child: Text(
                      placeDesc,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Closed - ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: 'Opens ' + placeOpenHour,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    padding: EdgeInsets.only(left: 15.0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/note_solid.svg',
                                width: 14.0,
                                height: 16.0,
                                color: Color(0XFF69A4FF),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Add note',
                                style: TextStyle(
                                  color: Color(0XFF69A4FF),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/share_solid.svg',
                                width: 14.0,
                                height: 16.0,
                                color: Color(0XFF69A4FF),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Share',
                                style: TextStyle(
                                  color: Color(0XFF69A4FF),
                                ),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/map_solid.svg',
                                width: 15.0,
                                height: 15.0,
                                color: Color(0XFF69A4FF),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Direction',
                                style: TextStyle(
                                  color: Color(0XFF69A4FF),
                                ),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
