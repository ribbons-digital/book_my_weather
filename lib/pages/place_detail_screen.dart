import 'package:despicables_me_app/widgets/place_detail_widget.dart';
import 'package:flutter/material.dart';

class PlaceDetail extends StatefulWidget {
  static const String id = 'placeDetail';

  @override
  _PlaceDetailState createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: height / 4,
            pinned: true,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 35.0,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 35.0,
                ),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
//                title: Text(
//                  'Taipei 101',
//                  style: TextStyle(
//                    color: Colors.white,
//                  ),
//                ),
                background: PageView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Image.asset(
                  'assets/images/taipei_101.jpg',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/images/shanghai.jpg',
                  fit: BoxFit.cover,
                ),
              ],
            )),
          ),
          SliverToBoxAdapter(
            child: PlaceDetailWidget(
              tabController: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}
