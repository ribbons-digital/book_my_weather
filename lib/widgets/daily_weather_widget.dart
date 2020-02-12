import 'package:flutter/material.dart';

class DailyWeather extends StatelessWidget {
  final String date;
  final String weatherConditionImgPath;
  final String tempRange;

  DailyWeather(
      {@required this.date,
      @required this.weatherConditionImgPath,
      @required this.tempRange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
//                                        top: 18.0,
//                                        bottom: 18.0,
          right: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    weatherConditionImgPath,
                    scale: 3.5,
                  ),
                  Text(
                    tempRange,
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 20,
                      color: Colors.white,
                    ),
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
