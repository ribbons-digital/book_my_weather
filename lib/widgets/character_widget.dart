import 'package:despicables_me_app/models/character.dart';
import 'package:despicables_me_app/pages/character_detail_screen.dart';
import 'package:despicables_me_app/styleguide.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../styleguide.dart';

class CharacterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 350),
                pageBuilder: (context, _, __) =>
                    CharacterDetailScreen(character: characters[0])));
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CharacterCardBackgroundClipper(),
              child: Hero(
                tag: "background-${characters[0].name}",
                child: Container(
                  height: 0.6 * screenHeight,
                  width: 0.9 * screenWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: characters[0].colors,
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(
                0, screenHeight / 10000 + screenHeight > 600 ? 0.3 : 0),
            child: Container(
              height: screenHeight / 2,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: "weather-icon",
                    child: Image.asset(
                      'assets/images/sunny.png',
                      scale: 1 / (screenHeight / 100) * 10,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 100,
                  ),
                  Text(
                    '26 º',
                    style: AppTheme.display1,
                  ),
                  Text(
                    '35º / 26º',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom:
                screenHeight > 600 ? screenHeight / 12 + 30 : screenHeight / 20,
            left: 15,
            right: 15,
            child: Container(
              width: screenWidth * 0.9,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '8AM',
                          style: AppTheme.small,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
//                          child: _SpinningSun(),
                          child: Image.asset(
                            'assets/images/sunny.png',
                            scale: 2.5,
                          ),
                        ),
                        Text(
                          '26º',
                          style: AppTheme.small,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '8AM',
                          style: AppTheme.small,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          child: Image.asset(
                            'assets/images/sunny.png',
                            scale: 2.5,
                          ),
                        ),
                        Text(
                          '26º',
                          style: AppTheme.small,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '8AM',
                          style: AppTheme.small,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          child: Image.asset(
                            'assets/images/sunny.png',
                            scale: 2.5,
                          ),
                        ),
                        Text(
                          '26º',
                          style: AppTheme.small,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '8AM',
                          style: AppTheme.small,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          child: Image.asset(
                            'assets/images/sunny.png',
                            scale: 2.5,
                          ),
                        ),
                        Text(
                          '26º',
                          style: AppTheme.small,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '8AM',
                          style: AppTheme.small,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          child: Image.asset(
                            'assets/images/sunny.png',
                            scale: 2.5,
                          ),
                        ),
                        Text(
                          '26º',
                          style: AppTheme.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CharacterCardBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
        1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width,
        size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0,
        size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.29);
    clippedPath.quadraticBezierTo(
        1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _SpinningSun extends StatefulWidget {
  @override
  __SpinningSunState createState() => __SpinningSunState();
}

class __SpinningSunState extends State<_SpinningSun> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.only(top: 5, bottom: 10),
      child: FlareActor(
        'assets/images/Spinning Sun.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'Spinning',
      ),
    );
  }
}
