import 'package:despicables_me_app/widgets/character_widget.dart';
import 'package:flutter/material.dart';

class CharacterListingScreen extends StatefulWidget {
  static const String id = 'home';
  @override
  _CharacterListingScreenState createState() => _CharacterListingScreenState();
}

class _CharacterListingScreenState extends State<CharacterListingScreen> {
  PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: currentPage,
      keepPage: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.arrow_back_ios),
        actions: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32.0, top: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Waverton",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 50,
                        ),
                      ),
                      TextSpan(text: "\n"),
                      TextSpan(text: "\n"),
                      TextSpan(
                        text: "Fri. 24th Jan.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: <Widget>[
                    CharacterWidget(),
                    CharacterWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
