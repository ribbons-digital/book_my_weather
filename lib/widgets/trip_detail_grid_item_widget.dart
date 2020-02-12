import 'package:flutter/material.dart';

class TripDetailGridItem extends StatelessWidget {
//  const TripDetailGridItem({
//    Key key,
//  }) : super(key: key);

  final String tag;
  final String gridImgPath;
  final String gridItemText;

  TripDetailGridItem(
      {@required this.tag,
      @required this.gridImgPath,
      @required this.gridItemText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: tag,
            child: Image.asset(
              gridImgPath,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Hero(
              tag: '$tag-text',
              child: Material(
                color: Color(0X00FFFFFF),
                child: Text(
                  gridItemText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
