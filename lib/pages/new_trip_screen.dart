import 'package:flutter/material.dart';

class NewTrip extends StatefulWidget {
  static const String id = 'newTrip';

  @override
  _NewTripState createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    iconSize: 40,
                    padding: EdgeInsets.all(0.0),
                    alignment: Alignment.centerLeft,
                    icon: Icon(Icons.close),
                    color: Colors.white.withOpacity(0.9),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Icon(
                    Icons.save,
                    color: Color(0XFF69A4FF),
                    size: 40.0,
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'New Trip',
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 40.0,
                  color: Color(0XFF69A4FF),
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Color(0XFF436DA6),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w100,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Destination',
                          hintStyle: TextStyle(
                            color: Color(0XFF436DA6),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w100,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Start Date',
                          hintStyle: TextStyle(
                            color: Color(0XFF436DA6),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w100,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'End Date',
                          hintStyle: TextStyle(
                            color: Color(0XFF436DA6),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w100,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(
                            color: Color(0XFF436DA6),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w100,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Note',
                          hintStyle: TextStyle(
                            color: Color(0XFF436DA6),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w100,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0XFF69A4FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
