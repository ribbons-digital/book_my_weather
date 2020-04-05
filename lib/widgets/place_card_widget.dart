import 'package:book_my_weather/app_localizations.dart';
import 'package:book_my_weather/models/networking_state.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/trip_todo.dart';
import 'package:book_my_weather/pages/trip_todos_screen.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
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

  void _onHandleAddTodo(Trip trip) async {
    final _db = DatabaseService();
    Provider.of<NetworkingState>(context, listen: false).setIsLoading(true);

    TripTodo tripTodo = TripTodo(
      content: toDoContent,
    );

    try {
      await _db.addTodoToTrip(trip.id, tripTodo);

      Navigator.pop(context);
      displaySuccessSnackbarWithAction(
          context: context,
          msg: AppLocalizations.of(context)
              .translate('place_card_bottom_sheet_todo_modal_success_string_1'),
          buttonText: AppLocalizations.of(context)
              .translate('place_card_bottom_sheet_todo_modal_success_string_2'),
          actionFn: () {
            Navigator.pushNamed(context, TripTodosScreen.id);
          });
    } on PlatformException catch (e) {
      Navigator.pop(context);
      displayErrorSnackbar(context, e.details);
    }

    Provider.of<NetworkingState>(context, listen: false).setIsLoading(false);
  }

  Column _buildBottomSheetMenu(BuildContext context) {
    final trips = Provider.of<List<Trip>>(context, listen: false);
    final tripIndex =
        Provider.of<TripState>(context, listen: false).selectedIndex;

    final isTripEnded =
        trips[tripIndex].endDateInMs < DateTime.now().millisecondsSinceEpoch;

    return Column(
      children: <Widget>[
        if (!isTripEnded)
          ListTile(
            leading: SvgPicture.asset(
              'assets/images/note_solid.svg',
              width: 14.0,
              height: 16.0,
              color: Color(0XFF69A4FF),
            ),
            title: Text(
              AppLocalizations.of(context)
                  .translate('place_card_bottom_sheet_option_1_string'),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      title: Text(AppLocalizations.of(context).translate(
                          'place_card_bottom_sheet_option_1_modal_title')),
                      content: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLength: null,
                        maxLines: null,
                        onChanged: (String newValue) {
                          setToDoContent(newValue);
                        },
                      ),
                      actions: <Widget>[
                        if (!Provider.of<NetworkingState>(context).isLoading)
                          FlatButton(
                            child: Text(AppLocalizations.of(context).translate(
                                'place_card_bottom_sheet_option_1_modal_cancel_btn_string')),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        if (!Provider.of<NetworkingState>(context).isLoading)
                          FlatButton(
                            child: Text(AppLocalizations.of(context).translate(
                                'place_card_bottom_sheet_option_1_modal_confirm_btn_string')),
                            onPressed: () async {
                              _onHandleAddTodo(trips[tripIndex]);
                            },
                          ),
                        if (Provider.of<NetworkingState>(context).isLoading)
                          SpinKitCircle(
                            size: 20.0,
                            color: Colors.black26,
                          ),
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
            AppLocalizations.of(context)
                .translate('place_card_bottom_sheet_option_2_string'),
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF69A4FF),
            ),
          ),
          onTap: () async {
            sharePlace(context, widget.placeId);
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
            AppLocalizations.of(context)
                .translate('place_card_bottom_sheet_option_3_string'),
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF69A4FF),
            ),
          ),
          onTap: () async {
            getPlaceDirection(context, widget.placeId);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final trips = Provider.of<List<Trip>>(context, listen: false);
    final tripIndex =
        Provider.of<TripState>(context, listen: false).selectedIndex;

    final isTripEnded =
        trips[tripIndex].endDateInMs < DateTime.now().millisecondsSinceEpoch;
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
                    subtitle: Text(
                      getSearchTypeStringWithLocalization(
                        context,
                        searchType(widget.placeCategory),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: isTripEnded ? 150 : 200,
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
                              text: widget.openNow
                                  ? AppLocalizations.of(context)
                                      .translate('place_card_open_now_string')
                                  : AppLocalizations.of(context)
                                      .translate('place_card_closed_string'),
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
