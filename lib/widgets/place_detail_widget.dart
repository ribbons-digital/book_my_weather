import 'package:despicables_me_app/widgets/explore_place_card_widget.dart';
import 'package:despicables_me_app/widgets/hourly_weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PlaceDetailWidget extends StatelessWidget {
  const PlaceDetailWidget({
    Key key,
    @required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 1350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Taipei 101'),
            subtitle: Text('Shopping'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Row(
              children: <Widget>[
                Text(
                  '4.5',
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
                  starCount: 5,
                  rating: 4.3,
                  size: 18.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Color(0XFF69A4FF),
                  borderColor: Color(0XFF69A4FF),
                  spacing: 0.0,
                ),
                Text(
                  '(45,867)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 8.0),
            child: Text(
              'Towering landmark skyscrapper offering shops, eateries and an observation platform on the 89th floor.',
              style: TextStyle(
                fontSize: 16.0,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Closed - ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(
                    text: 'Opens 11am',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 40.0,
            padding: EdgeInsets.only(left: 15.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Color(0XFF69A4FF),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.phone,
                        color: Color(0XFF69A4FF),
                      ),
//                      SvgPicture.asset(
//                        'assets/images/note_solid.svg',
//                        width: 14.0,
//                        height: 16.0,
//                        color: Color(0XFF69A4FF),
//                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Call',
                        style: TextStyle(
                          color: Color(0XFF69A4FF),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  width: 20.0,
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        color: Color(0XFF69A4FF),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: Color(0XFF69A4FF),
                        ),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Color(0XFF69A4FF),
                    ),
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  width: 20.0,
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.bookmark,
                        color: Color(0XFF69A4FF),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Save',
                        style: TextStyle(
                          color: Color(0XFF69A4FF),
                        ),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Color(0XFF69A4FF),
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Divider(
                color: Colors.black26,
              ),
            ),
          ),
          Center(
            child: TabBar(
              isScrollable: true,
              labelColor: Color(0XFF69A4FF),
              unselectedLabelColor: Colors.black26,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 10.0,
              indicatorColor: Color(0XFF69A4FF),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 8.0),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: Text('Overview'),
                ),
                Tab(
                  child: Text('Weather'),
                ),
                Tab(
                  child: Text('Photos'),
                ),
                Tab(
                  child: Text('Notes'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
//                PlaceOverview(height: height, width: width,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: List.generate(5, (i) {
                          return HourlyWeatherWidget(
                            hour: '8am',
                            temperature: '31',
                            weatherIconPath: 'assets/images/sunny.png',
                          );
                        }),
                      ),
                    )
                  ],
                ),
                Text('3'),
                Text('4'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceOverview extends StatelessWidget {
  const PlaceOverview({
    Key key,
    @required this.height,
    @required this.width,
    @required this.goToWeatherTab,
  }) : super(key: key);

  final double height;
  final double width;
  final Function goToWeatherTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: Text(
              'Information',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              bottom: 10.0,
            ),
            child: Text(
              'No.7, Section 5, Xinyi Road, Xinyi District, Taipei City, Taiwan 110',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w100,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              bottom: 10.0,
            ),
            child: Text(
              '(02) 98300123',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              bottom: 10.0,
            ),
            child: Text(
              'https://www.taipei101.com.tw',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Divider(
                color: Colors.black26,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: Text(
              'Business hours',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Monday  11:00am ~ 09:00pm',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  'Tuesday  11:00am ~ 09:00pm',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  'Wednesday  11:00am ~ 09:00pm',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  'Thursday  11:00am ~ 09:00pm',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  'Friday  11:00am ~ 09:00pm',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  'Saturday  11:00am ~ 09:00pm',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  'Sunday  11:00am ~ 09:00pm',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Divider(
                color: Colors.black26,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: Text(
              'Weather forecast',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: goToWeatherTab,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  7,
                  (i) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '2/' + (int.parse('4') + i).toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
//                          child: _SpinningSun(),
                        child: Image.asset(
                          'assets/images/sunny.png',
                          scale: 3.5,
                        ),
                      ),
                      Text(
                        '26º',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Divider(
                      color: Colors.black26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    top: 16.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    'Hotels nearby',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(5, (i) {
                      return AspectRatio(
                        aspectRatio: height < 600
                            ? width / height
                            : (width * 1.1) / height,
                        child: ExplorePlaceCardWidget(),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
