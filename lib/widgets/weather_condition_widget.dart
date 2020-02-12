import 'package:flutter/material.dart';

class WeatherCondition extends StatelessWidget {
  final IconData icon;
  final String conditionName;
  final String condition;

  WeatherCondition({this.icon, this.conditionName, this.condition});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth < 600 ? screenWidth / 3.2 : screenWidth / 3.5,
      height: screenWidth < 600 ? screenWidth / 3.2 : screenWidth / 3.5,
      decoration: BoxDecoration(
          color: Color(0XFFC3C5C8),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
//              color: Colors.white,
              size: 30.0,
            ),
            Text(
              conditionName,
              style: TextStyle(
//                color: Colors.white,
                fontSize: 15.0,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              condition,
              style: TextStyle(
//                color: Colors.white,
                fontSize: 20.0,
                fontFamily: 'Roboto',
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
