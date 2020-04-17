import 'package:book_my_weather/secure/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

class NativeAdWidget extends StatefulWidget {
  @override
  NativeAdWidgetState createState() => NativeAdWidgetState();
}

class NativeAdWidgetState extends State<NativeAdWidget> {
  static const _iOSAdUnitID = kAdMobIosAdUnit;
  static const _androidAdUnitId = kAdMobAndroidAdUnit;
  final _controller = NativeAdmobController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Container(
      height: 300.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border(
          bottom: BorderSide(
            color: Color(0X42FFFFFF),
          ),
        ),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      child: NativeAdmob(
        // dev
//        adUnitID: kTestAdUnit,
        // production
        adUnitID: isIos ? _iOSAdUnitID : _androidAdUnitId,
        controller: _controller,
        type: NativeAdmobType.full,
      ),
    );
  }
}
