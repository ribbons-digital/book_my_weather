import 'package:book_my_weather/app_localizations.dart';
import 'package:book_my_weather/models/networking_state.dart';
import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/trip_todo.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:book_my_weather/utilities/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

enum TodoAction {
  Add,
  Edit,
  Delete,
}

class TripTodosScreen extends StatefulWidget {
  static const String id = 'tripTodosScreen';

  @override
  _TripTodosScreenState createState() => _TripTodosScreenState();
}

class _TripTodosScreenState extends State<TripTodosScreen> {
  TextEditingController _editingController;
  String toDoContent = '';
  final _db = DatabaseService();

  void _onHandleAddTodo(Trip trip) async {
    Provider.of<NetworkingState>(context, listen: false).setIsLoading(true);

    TripTodo tripTodo = TripTodo(
      content: toDoContent,
    );

    try {
      await _db.addTodoToTrip(trip.id, tripTodo);

      Navigator.pop(context);
      displaySuccessSnackbar(
        context,
        AppLocalizations.of(context)
            .translate('trip_todos_screen_add_todo_success_msg'),
      );
    } on PlatformException catch (e) {
      Navigator.pop(context);
      displayErrorSnackbar(context, e.details);
    }

    Provider.of<NetworkingState>(context, listen: false).setIsLoading(false);
  }

  void _onHandleEditTodo(
      {TodoAction action, Trip trip, TripTodo tripTodo}) async {
    Provider.of<NetworkingState>(context, listen: false).setIsLoading(true);
    if (action == TodoAction.Edit) {
      try {
        await _db.updateTripTodoContent(trip.id, tripTodo.id, toDoContent);

        Navigator.pop(context);
        displaySuccessSnackbar(
            context,
            AppLocalizations.of(context)
                .translate('trip_todos_screen_edit_todo_success_msg'));
      } on PlatformException catch (e) {
        Navigator.pop(context);
        displayErrorSnackbar(context, e.details);
      }

      Provider.of<NetworkingState>(context, listen: false).setIsLoading(false);
    }
  }

  Column _buildBottomSheetMenu(
      BuildContext context, TripTodo tripTodo, Trip trip) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Color(0XFF69A4FF),
          ),
          title: Text(
            AppLocalizations.of(context)
                .translate('trips_todos_screen_bottom_sheet_option_1_string'),
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF69A4FF),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            _editingController.text = tripTodo.content;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)
                          .translate('trip_todos_screen_edit_todo_modal_title'),
                    ),
                    content: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0XFF69A4FF),
                          ),
                        ),
                      ),
                      controller: _editingController,
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      onChanged: (String newValue) {
                        toDoContent = newValue;
                      },
                    ),
                    actions: <Widget>[
                      if (!Provider.of<NetworkingState>(context).isLoading)
                        FlatButton(
                          child: Text(AppLocalizations.of(context).translate(
                              'trip_todos_screen_edit_todo_modal_cancel_btn_string')),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      if (!Provider.of<NetworkingState>(context).isLoading)
                        FlatButton(
                          child: Text(AppLocalizations.of(context).translate(
                              'trip_todos_screen_edit_todo_modal_confirm_btn_string')),
                          onPressed: () {
                            _onHandleEditTodo(
                                action: TodoAction.Edit,
                                trip: trip,
                                tripTodo: tripTodo);
                          },
                        ),
                      if (Provider.of<NetworkingState>(context).isLoading)
                        SpinKitCircle(
                          size: 20.0,
                          color: Colors.black26,
                        ),
                    ],
                  );
                });
          },
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Color(0XFF69A4FF)),
          title: Text(
            AppLocalizations.of(context)
                .translate('trips_todos_screen_bottom_sheet_option_2_string'),
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0XFF69A4FF),
            ),
          ),
          onTap: () async {
            final trips = Provider.of<List<Trip>>(context, listen: false);
            final tripIndex =
                Provider.of<TripState>(context, listen: false).selectedIndex;
            await _db.deleteTripTodo(trips[tripIndex].id, tripTodo.id);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trips = Provider.of<List<Trip>>(context);
    final tripIndex = Provider.of<TripState>(context).selectedIndex;
    final _db = DatabaseService();
    final isTripEnded = Provider.of<TripState>(context).isTripEnded;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            iconSize: 40,
            icon: Icon(Icons.chevron_left),
            color: Colors.white.withOpacity(0.9),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            if (!isTripEnded)
              IconButton(
                icon: Icon(Icons.add),
                iconSize: 40,
                color: Colors.white.withOpacity(0.9),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          title: Text(AppLocalizations.of(context).translate(
                              'trip_todos_screen_add_todo_modal_title')),
                          content: TextField(
                            autocorrect: true,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0XFF69A4FF),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            autofocus: true,
                            maxLength: null,
                            maxLines: null,
                            onChanged: (String newValue) {
                              setState(() {
                                toDoContent = newValue;
                              });
                            },
                          ),
                          actions: <Widget>[
                            if (!Provider.of<NetworkingState>(context)
                                .isLoading)
                              FlatButton(
                                child: Text(AppLocalizations.of(context).translate(
                                    'trip_todos_screen_add_todo_modal_cancel_btn_string')),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            if (!Provider.of<NetworkingState>(context)
                                .isLoading)
                              FlatButton(
                                child: Text(AppLocalizations.of(context).translate(
                                    'trip_todos_screen_add_todo_modal_confirm_btn_string')),
                                onPressed: () {
                                  _onHandleAddTodo(trips[tripIndex]);
                                },
                              ),
                            if (Provider.of<NetworkingState>(context).isLoading)
                              SpinKitCircle(
                                size: 20.0,
                                color: Colors.black26,
                              )
                          ],
                        );
                      });
                },
              ),
          ],
          title: Text(AppLocalizations.of(context)
              .translate('trip_todos_screen_title_string')),
        ),
        body: StreamProvider<List<TripTodo>>.value(
          value: _db.streamTripTodos(trips[tripIndex].id),
          child: Consumer<List<TripTodo>>(builder: (_, tripToDos, __) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (tripToDos == null || tripToDos.length == 0)
                  Text(
                    AppLocalizations.of(context)
                        .translate('trip_todos_screen_no_todos_msg_string'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (tripToDos != null && tripToDos.length > 0)
                  Expanded(
                    child: ListView.builder(
                      itemCount: tripToDos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0X42FFFFFF),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (!isTripEnded)
                                  IconButton(
                                    icon: Icon(
                                      tripToDos[index].isFinished
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () async {
                                      await _db.toggleTripTodoStatus(
                                        trips[tripIndex].id,
                                        tripToDos[index].id,
                                        tripToDos[index].isFinished,
                                      );
                                      if (!isTripEnded) {
                                        await _db.deleteTripTodo(
                                            trips[tripIndex].id,
                                            tripToDos[index].id);
                                      }
                                    },
                                  ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.65,
                                  margin: EdgeInsets.all(
                                    5.0,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      tripToDos[index].content,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isTripEnded)
                                  IconButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 150,
                                              child: _buildBottomSheetMenu(
                                                  context,
                                                  tripToDos[index],
                                                  trips[tripIndex]),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
