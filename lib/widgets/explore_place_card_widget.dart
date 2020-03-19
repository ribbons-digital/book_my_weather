import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ExplorePlaceCardWidget extends StatelessWidget {
  final String name;
  final String placeId;
  final String type;
  final double rating;
  final int ratingTotals;
  final bool openNow;
  final String photo;

  ExplorePlaceCardWidget({
    this.name,
    this.placeId,
    this.type,
    this.ratingTotals,
    this.rating,
    this.openNow,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: 0.45,
              widthFactor: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: photo.contains('https')
                    ? Image.network(
                        photo,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        photo,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.9),
            child: FractionallySizedBox(
              heightFactor: 0.55,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        name,
                        maxLines: 3,
                      ),
                      subtitle: Text(type),
                      contentPadding: EdgeInsets.only(
                        left: 0.0,
                        bottom: 0.0,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '$rating ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        SmoothStarRating(
                          allowHalfRating: true,
                          onRatingChanged: (v) {
//                              rating = v;
//                              setState(() {});
                          },
                          starCount: 1,
                          rating: rating,
                          size: 18.0,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Color(0XFF69A4FF),
                          borderColor: Color(0XFF69A4FF),
                          spacing: 0.0,
                        ),
                        Text(
                          ratingTotals != null ? ' ($ratingTotals)' : ' (0)',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
//                    if (openNow != null)
//                      FittedBox(
//                        fit: BoxFit.contain,
//                        child: RichText(
//                          text: TextSpan(
//                            children: [
//                              TextSpan(
//                                text: openNow ? 'Open now' : 'Closed',
//                                style: TextStyle(
//                                  color: openNow ? Colors.green : Colors.red,
//                                  fontSize: 15,
//                                ),
//                              ),
////                            TextSpan(
////                              text: 'Opens 11am',
////                              style: TextStyle(
////                                color: Colors.black,
////                                fontSize: 15,
////                              ),
////                            ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text('31º currently'),
//                        SvgPicture.asset(
//                          'assets/images/sunny.svg',
//                          color: Colors.black,
//                          semanticsLabel: 'sunny-line',
//                        ),
//                      ],
//                    ),
                  ],
                ),
              ),
            ),
          ),
//          Align(
//            alignment: Alignment(0.9, -0.9),
//            child: Container(
//              width: 40,
//              height: 40,
//              alignment: Alignment.center,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(50.0),
//                color: Color(0x42000000),
//              ),
//              child: IconButton(
//                icon: Icon(Icons.more_vert),
//                color: Colors.white,
//                onPressed: () {},
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
