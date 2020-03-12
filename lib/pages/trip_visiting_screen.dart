import 'dart:math' as math;

import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/trip_visiting.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripVisitingScreen extends StatefulWidget {
  static const String id = 'tripVisitingScreen';

  @override
  _TripVisitingScreenState createState() => _TripVisitingScreenState();
}

class _TripVisitingScreenState extends State<TripVisitingScreen> {
//  List<List<DocumentSnapshot>> _docs;
//  Future _saving;

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

  Widget _renderTripVisitingList(
      BuildContext context, List<TripVisiting> tripVisitings) {
    final db = DatabaseService();
    final tripId = Provider.of<TripState>(context).tripId;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    List dates = Set.from(tripVisitings.map((v) => v.visitingDate)).toList();
    List<List<TripVisiting>> sortByDateList = dates.map((d) {
      return tripVisitings
          .map((v) {
            if (v.visitingDate == d) {
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
          itemCount: dates.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: height / 10 * sortByDateList[index].length +
                  50 +
                  (sortByDateList[index].length * 8),
              child: Column(
                children: <Widget>[
                  Text(
                    timeStampToDateString(dates[index]),
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
                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                        ),
                        key: ValueKey(sortByDateList[index][i].id),
                        onDismissed: (DismissDirection direction) async {
                          await db.deleteTripVisiting(
                              tripId, sortByDateList[index][i].id);
                        },
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
