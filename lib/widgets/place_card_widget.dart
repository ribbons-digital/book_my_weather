import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/trip_todo.dart';
import 'package:book_my_weather/secure/keys.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PlaceCard extends StatefulWidget {
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

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  String toDoContent = '';

  void setToDoContent(String newContent) {
    setState(() {
      toDoContent = newContent;
    });
  }

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
            'Add a ToDo',
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF69A4FF),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add a ToDo'),
                    content: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      onChanged: (String newValue) {
                        setToDoContent(newValue);
                      },
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('Add'),
                        onPressed: () async {
                          final trips =
                              Provider.of<List<Trip>>(context, listen: false);
                          final tripIndex =
                              Provider.of<TripState>(context, listen: false)
                                  .selectedIndex;
                          final db = DatabaseService();

                          TripTodo tripTodo = TripTodo(
                            content: toDoContent,
                          );
                          await db.addTodoToTrip(trips[tripIndex].id, tripTodo);
//                          Scaffold.of(context).showSnackBar(
//                            SnackBar(
//                              content: Text('ToDo Added.'),
//                            ),
//                          );
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          },
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
                'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=url&place_id=${widget.placeId}';
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
                'https://maps.googleapis.com/maps/api/place/details/json?key=$kGooglePlacesAPIKey&fields=formatted_address&place_id=${widget.placeId}';
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
                child: widget.placeImgPath.contains('https')
                    ? Image.network(
                        widget.placeImgPath,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        widget.placeImgPath,
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
                    title: Text(widget.placeName),
                    subtitle: Text(widget.placeCategory.split('_').join(' ')),
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
                          widget.placeRating.toString(),
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
                          rating: widget.placeRating,
                          size: 18.0,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Color(0XFF69A4FF),
                          borderColor: Color(0XFF69A4FF),
                          spacing: 0.0,
                        ),
                        Text(
                          widget.placeReview,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.openNow != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.openNow ? 'Open now' : 'Closed',
                              style: TextStyle(
                                color:
                                    widget.openNow ? Colors.green : Colors.red,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!widget.isExplore)
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
