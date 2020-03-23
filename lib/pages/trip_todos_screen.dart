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
      displaySuccessSnackbar(context, 'Todo successfully added.');
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
        displaySuccessSnackbar(context, 'Todo successfully edited.');
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
            'Edit this todo',
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
                    title: Text('Edit ToDo'),
                    content: TextField(
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
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      if (!Provider.of<NetworkingState>(context).isLoading)
                        FlatButton(
                          child: Text('Save'),
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
            'Delete this todo',
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
            IconButton(
              icon: Icon(Icons.add),
              iconSize: 40,
              color: Colors.white.withOpacity(0.9),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add a ToDo'),
                        content: TextField(
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
                          if (!Provider.of<NetworkingState>(context).isLoading)
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          if (!Provider.of<NetworkingState>(context).isLoading)
                            FlatButton(
                              child: Text('Save'),
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
          title: Text('To Dos'),
        ),
        body: StreamProvider<List<TripTodo>>.value(
          value: _db.streamTripTodos(trips[tripIndex].id),
          child: Consumer<List<TripTodo>>(builder: (_, tripToDos, __) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (tripToDos == null || tripToDos.length == 0)
                  Text(
                    'No todos yet. Tap the " + " button to add a new to do.',
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
                          margin: EdgeInsets.all(
                            8.0,
                          ),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(tripToDos[index].isFinished
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank),
                                onPressed: () async {
                                  await _db.toggleTripTodoStatus(
                                      trips[tripIndex].id,
                                      tripToDos[index].id,
                                      tripToDos[index].isFinished);
                                },
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.65,
                                margin: EdgeInsets.all(
                                  5.0,
                                ),
                                child: Text(
                                  tripToDos[index].content,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.more_vert),
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
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                        );
                                      });
                                },
                              ),
                            ],
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
