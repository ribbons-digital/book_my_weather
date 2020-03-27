import 'package:flutter/material.dart';

class AppTheme {
  static const TextStyle display1 = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
    fontSize: 48,
    fontWeight: FontWeight.w100,
    letterSpacing: 1.2,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w100,
    letterSpacing: 1.0,
  );

  static final TextStyle heading = TextStyle(
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w900,
    fontSize: 34,
    color: Colors.white.withOpacity(0.8),
    letterSpacing: 1.2,
  );

  static final TextStyle subHeading = TextStyle(
    inherit: true,
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: Colors.white.withOpacity(0.8),
  );

  static final TextStyle small = TextStyle(
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );
}
