import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TripWidget extends StatelessWidget {
  final String imgPath;
  final String currentTemp;
  final String precipitation;
  final String tripName;
  final String city;
  final String startDate;
  final int index;

  TripWidget({
    @required this.imgPath,
    this.currentTemp = '31',
    this.precipitation = '0',
    @required this.tripName,
    @required this.city,
    this.startDate = '2020-02-20 00:00:00.000',
    @required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String daysLeft =
        DateTime.parse(startDate).difference(DateTime.now()).inDays.toString();
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width - 40
            : MediaQuery.of(context).size.width - 100,
        height: 161,
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(12.0),
//          image: DecorationImage(
//            image: AssetImage(imgPath),
//            fit: BoxFit.cover,
//            colorFilter: new ColorFilter.mode(
//                Colors.black.withOpacity(0.6), BlendMode.dstATop),
//          ),
//        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'card-background-$index',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.black,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Hero(
                tag: 'city-img-$index',
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: 'tempIcon-$index',
                            child: SvgPicture.asset('assets/images/sunny.svg',
                                color: Colors.white,
                                semanticsLabel: 'sunny-line'),
                          ),
                          Hero(
                            tag: 'temp-$index',
                            child: Material(
                              color: Color(0X00FFFFFF),
                              child: Text(
                                '$currentTempº currently',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Hero(
                        tag: 'precipitation-$index',
                        child: Material(
                          color: Color(0X00FFFFFF),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/rain-solid.png'),
                              Text(
                                '$precipitation%',
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Hero(
                        tag: 'city-$index',
                        child: Material(
                          color: Color(0X00FFFFFF),
                          child: Text(
                            city,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'tripName-$index',
                        child: Material(
                          color: Color(0X00FFFFFF),
                          child: Text(
                            tripName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: 'timer-icon-$index',
                            child: Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                          ),
                          Hero(
                            tag: 'daysLeft-$index',
                            child: Material(
                              color: Color(0X00FFFFFF),
                              child: Text(
                                '$daysLeft days, from today',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Hero(
                        tag: 'startDate-$index',
                        child: Material(
                          color: Color(0X00FFFFFF),
                          child: Text(
                            DateFormat.yMd('en_US')
                                .format(DateTime.parse(startDate)),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
