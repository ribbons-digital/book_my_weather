import 'dart:math' as math;

import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/trip_visiting.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      final time = '${pickedTime.hour} : ${pickedTime.minute}';
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
              height: height / 10 * sortByDateList[index].length +
                  50 +
                  (sortByDateList[index].length * 8),
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
//                  Expanded(
//                    child: ReorderableListView(
//                      onReorder: (oldIndex, newIndex) {
//                        _updateMyItems(oldIndex, newIndex);
//                      },
//                      children:
//                          List.generate(sortByDateList[index].length, (i) {
//                        return Container(
//                          width: width,
//                          height: height / 10,
//                          key: ValueKey(sortByDateList[index][i].id),
//                          color: Colors.white,
//                          margin: EdgeInsets.all(
//                            8.0,
//                          ),
//                          padding: EdgeInsets.all(
//                            8.0,
//                          ),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Container(
//                                width: width / 1.8,
//                                child: ListTile(
//                                  title: Text(
//                                    sortByDateList[index][i].placeName,
//                                    style: TextStyle(
//                                      fontSize: 18.0,
//                                    ),
//                                  ),
//                                  subtitle:
//                                      Text(sortByDateList[index][i].placeType),
//                                ),
//                              ),
//                              Image.network(
//                                buildPhotoURL(sortByDateList[index][i].photo),
//                                fit: BoxFit.cover,
//                                width: width / 4,
//                              )
//                            ],
//                          ),
//                        );
//                      }),
//                    ),
//                  )
                  Column(
                    children: List.generate(sortByDateList[index].length, (i) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Edit',
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
                              print(time);
                              setState(() {
                                visitingDate = date;
                                visitingTime = time;
                              });
                              _dateEditingController.text =
                                  DateFormat('yMMMMd').format(date);
                              _timeEditingController.text =
                                  '${time.hour}:${time.minute}';
                              if (_dateEditingController != null &&
                                  _timeEditingController != null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('When are you visiting?'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextField(
                                              style: TextStyle(
                                                  color: Color(0XFF436DA6)),
                                              controller:
                                                  _dateEditingController,
                                              onTap: () async {
                                                pickDate(context);
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Select Date',
                                                hintStyle: TextStyle(
                                                  color: Color(0XFF436DA6),
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w100,
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
                                                hintText: 'Select Time',
                                                hintStyle: TextStyle(
                                                  color: Color(0XFF436DA6),
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w100,
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
                                          FlatButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Save'),
                                            onPressed: () async {
                                              if (visitingDate == null ||
                                                  visitingTime == null) return;
                                              final visitingDateTime = DateTime(
                                                  visitingDate.year,
                                                  visitingDate.month,
                                                  visitingDate.day,
                                                  visitingTime.hour,
                                                  visitingTime.minute);
                                              TripVisiting updatedTripVisiting =
                                                  TripVisiting(
                                                id: sortByDateList[index][i].id,
                                                photo: sortByDateList[index][i]
                                                    .photo,
                                                placeId: sortByDateList[index]
                                                        [i]
                                                    .placeId,
                                                placeName: sortByDateList[index]
                                                        [i]
                                                    .placeName,
                                                placeType: sortByDateList[index]
                                                        [i]
                                                    .placeType,
                                                visitingDate: Timestamp
                                                    .fromMicrosecondsSinceEpoch(
                                                        visitingDateTime
                                                                .millisecondsSinceEpoch *
                                                            1000),
                                              );

                                              await db.updateTripVisiting(
                                                  tripId, updatedTripVisiting);
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () async {
                              await db.deleteTripVisiting(
                                  tripId, sortByDateList[index][i].id);
                            },
                          ),
                        ],
                        child: Container(
                          width: width,
                          height: height / 10,
                          color: Colors.white,
                          margin: EdgeInsets.all(
                            8.0,
                          ),
                          padding: EdgeInsets.all(
                            8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: width / 1.8,
                                child: ListTile(
                                  title: Text(
                                    sortByDateList[index][i].placeName,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  subtitle:
                                      Text(sortByDateList[index][i].placeType),
                                ),
                              ),
                              Image.network(
                                buildPhotoURL(sortByDateList[index][i].photo),
                                fit: BoxFit.cover,
                                width: width / 4,
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
                title: Text('Visitings'),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  if (tripVisitings == null || tripVisitings.length == 0)
                    Text(
                      'You haven\'t bookmarked any places yet. You can start by exploring places in this city and tap on "Save" to save them in this page.',
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
