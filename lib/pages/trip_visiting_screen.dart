import 'dart:math' as math;

import 'package:book_my_weather/app_localizations.dart';
import 'package:book_my_weather/models/networking_state.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/trip_visiting.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TripVisitingScreen extends StatefulWidget {
  static const String id = 'tripVisitingScreen';

  @override
  _TripVisitingScreenState createState() => _TripVisitingScreenState();
}

class _TripVisitingScreenState extends State<TripVisitingScreen> {
  TextEditingController _dateEditingController;
  TextEditingController _timeEditingController;
  DateTime visitingDate;
  TimeOfDay visitingTime;

  SliverPersistentHeader makeHeader(Widget child) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 60.0,
        child: child,
      ),
    );
  }

//  _updateMyItems(int oldIndex, int newIndex) {
//    if (oldIndex < newIndex) newIndex -= 1;
//    _docs.insert(newIndex, _docs.removeAt(oldIndex));
//    final futures = <Future>[];
//    for (int pos = 0; pos < _docs.length; pos++) {
//      futures.add(_docs[pos].reference.updateData({widget.indexKey: pos}));
//    }
//    setState(() {
//      _saving = Future.wait(futures);
//    });
//  }

  void pickDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));

    if (pickedDate != null && pickedDate != DateTime.now()) {
      _dateEditingController.text = DateFormat('yMMMMd').format(pickedDate);
      setState(() {
        visitingDate = pickedDate;
      });
    }
  }

  void pickTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final minute = pickedTime.minute <= 10
          ? '0${pickedTime.minute}'
          : pickedTime.minute.toString();
      final time = '${pickedTime.hour} : $minute';
      _timeEditingController.text = time;
      setState(() {
        visitingTime = pickedTime;
      });
    }
  }

  Widget _renderTripVisitingList(
      BuildContext context, List<TripVisiting> tripVisitings) {
    final db = DatabaseService();
    final tripId = Provider.of<TripState>(context).tripId;
    final width = MediaQuery.of(context).size.width;

    final isTripEnded = Provider.of<TripState>(context).isTripEnded;

    List timeStamps = Set.from(tripVisitings.map((v) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
          v.visitingDate.millisecondsSinceEpoch);
      final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
      return Timestamp.fromDate(date);
    })).toList();

    List<List<TripVisiting>> sortByDateList = timeStamps.map((d) {
      return tripVisitings
          .map((v) {
            final visitingDate1 =
                v.visitingDate.toDate().month + v.visitingDate.toDate().day;
            final visitingDate2 =
                (d as Timestamp).toDate().month + (d as Timestamp).toDate().day;
            if (visitingDate1 == visitingDate2) {
              return v;
            }
            return null;
          })
          .toList()
          .where((e) => e != null)
          .toList();
    }).toList();

    return Expanded(
      child: ListView.builder(
          itemCount: timeStamps.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
//              decoration: BoxDecoration(
//                color: Colors.white,
//                borderRadius: BorderRadius.circular(12.0),
//              ),
              child: Column(
                children: <Widget>[
                  Text(
                    timeStampToDateString(timeStamps[index]),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: 28.0,
                    ),
                  ),
                  Column(
                    children: List.generate(sortByDateList[index].length, (i) {
                      final minute = sortByDateList[index][i]
                                  .visitingDate
                                  .toDate()
                                  .minute <
                              10
                          ? '0${sortByDateList[index][i].visitingDate.toDate().minute}'
                          : '${sortByDateList[index][i].visitingDate.toDate().minute}';
                      return Slidable(
                        enabled: !isTripEnded,
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: AppLocalizations.of(context).translate(
                                'trip_visitings_screen_slide_action_option_1_string'),
                            color: Colors.blue,
                            icon: Icons.edit,
                            onTap: () {
                              final visitingDateTime = sortByDateList[index][i]
                                  .visitingDate
                                  .toDate();
                              final date = DateTime(visitingDateTime.year,
                                  visitingDateTime.month, visitingDateTime.day);
                              final time =
                                  TimeOfDay.fromDateTime(visitingDateTime);
                              final minute = time.minute <= 10
                                  ? '0${time.minute}'
                                  : time.minute.toString();
                              setState(() {
                                visitingDate = date;
                                visitingTime = time;
                              });
                              _dateEditingController.text =
                                  DateFormat('yMMMMd').format(date);
                              _timeEditingController.text =
                                  '${time.hour}:$minute';
                              if (_dateEditingController != null &&
                                  _timeEditingController != null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(AppLocalizations.of(context)
                                            .translate(
                                                'trip_visitings_screen_edit_modal_title')),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextField(
                                              autofocus: true,
                                              style: TextStyle(
                                                  color: Color(0XFF436DA6)),
                                              controller:
                                                  _dateEditingController,
                                              onTap: () async {
                                                pickDate(context);
                                              },
                                              decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'trip_visitings_screen_edit_modal_field_1_hint_text'),
                                                hintStyle: TextStyle(
                                                  color: Color(0XFF436DA6),
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w100,
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0XFF69A4FF),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0XFF69A4FF),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            TextField(
                                              style: TextStyle(
                                                  color: Color(0XFF436DA6)),
                                              controller:
                                                  _timeEditingController,
                                              onTap: () async {
                                                pickTime(context);
                                              },
                                              decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'trip_visitings_screen_edit_modal_field_2_hint_text'),
                                                hintStyle: TextStyle(
                                                  color: Color(0XFF436DA6),
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w100,
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0XFF69A4FF),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0XFF69A4FF),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          if (!Provider.of<NetworkingState>(
                                                  context)
                                              .isLoading)
                                            FlatButton(
                                              child: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'trip_visitings_screen_edit_modal_cancel_btn_string')),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          if (!Provider.of<NetworkingState>(
                                                  context)
                                              .isLoading)
                                            FlatButton(
                                              child: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'trip_visitings_screen_edit_modal_confirm_btn_string')),
                                              onPressed: () async {
                                                if (visitingDate == null ||
                                                    visitingTime == null)
                                                  return;
                                                Provider.of<NetworkingState>(
                                                        context,
                                                        listen: false)
                                                    .setIsLoading(true);
                                                final visitingDateTime =
                                                    DateTime(
                                                        visitingDate.year,
                                                        visitingDate.month,
                                                        visitingDate.day,
                                                        visitingTime.hour,
                                                        visitingTime.minute);
                                                TripVisiting
                                                    updatedTripVisiting =
                                                    TripVisiting(
                                                  id: sortByDateList[index][i]
                                                      .id,
                                                  photo: sortByDateList[index]
                                                          [i]
                                                      .photo,
                                                  placeId: sortByDateList[index]
                                                          [i]
                                                      .placeId,
                                                  placeName:
                                                      sortByDateList[index][i]
                                                          .placeName,
                                                  placeType:
                                                      sortByDateList[index][i]
                                                          .placeType,
                                                  visitingDate: Timestamp
                                                      .fromMicrosecondsSinceEpoch(
                                                          visitingDateTime
                                                                  .millisecondsSinceEpoch *
                                                              1000),
                                                );

                                                try {
                                                  await db.updateTripVisiting(
                                                      tripId,
                                                      updatedTripVisiting);
                                                  Provider.of<NetworkingState>(
                                                          context,
                                                          listen: false)
                                                      .setIsLoading(false);
                                                  Navigator.pop(context);
                                                  displaySuccessSnackbar(
                                                      context,
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              'trip_visitings_screen_update_success_msg_string'));
                                                } on PlatformException catch (e) {
                                                  Provider.of<NetworkingState>(
                                                          context,
                                                          listen: false)
                                                      .setIsLoading(false);
                                                  Navigator.pop(context);
                                                  displayErrorSnackbar(
                                                      context, e.details);
                                                }
                                              },
                                            ),
                                          if (Provider.of<NetworkingState>(
                                                  context)
                                              .isLoading)
                                            SpinKitCircle(
                                              size: 20.0,
                                              color: Colors.black26,
                                            )
                                        ],
                                      );
                                    });
                              }
                            },
                          ),
                          IconSlideAction(
                            caption: AppLocalizations.of(context).translate(
                                'trip_visitings_screen_slide_action_option_2_string'),
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () async {
                              await db.deleteTripVisiting(
                                  tripId, sortByDateList[index][i].id);
                            },
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0X42FFFFFF),
                              ),
                            ),
                          ),
                          width: width,
                          margin: EdgeInsets.all(
                            8.0,
                          ),
                          padding: EdgeInsets.all(
                            8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: width / 1.8,
                                    child: ListTile(
                                      title: Text(
                                        sortByDateList[index][i].placeName,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        getSearchTypeStringWithLocalization(
                                          context,
                                          searchType(sortByDateList[index][i]
                                              .placeType),
                                        ),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                    ),
                                    child: Text(
                                      '${AppLocalizations.of(context).translate('trip_visitings_screen_item_time_string')} ${sortByDateList[index][i].visitingDate.toDate().hour}:$minute',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  buildPhotoURL(sortByDateList[index][i].photo),
                                  fit: BoxFit.cover,
                                  width: width / 4,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _dateEditingController = TextEditingController();
    _timeEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _dateEditingController.dispose();
    _timeEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final tripId = Provider.of<TripState>(context).tripId;

    return StreamProvider<List<TripVisiting>>.value(
      value: db.streamTripVisitings(tripId),
      child: Consumer<List<TripVisiting>>(
        builder: (_, tripVisitings, __) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.chevron_left),
                  color: Colors.white.withOpacity(0.9),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(AppLocalizations.of(context)
                    .translate('trip_visitings_screen_title')),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  if (tripVisitings == null || tripVisitings.length == 0)
                    Text(
                      AppLocalizations.of(context)
                          .translate('trip_visitings_no_visitings_msg_string'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w200,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (tripVisitings != null && tripVisitings.length > 0)
                    _renderTripVisitingList(context, tripVisitings),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
