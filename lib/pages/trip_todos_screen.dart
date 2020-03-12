import 'package:book_my_weather/models/trip.dart';
import 'package:book_my_weather/models/trip_state.dart';
import 'package:book_my_weather/models/trip_todo.dart';
import 'package:book_my_weather/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripTodosScreen extends StatefulWidget {
  static const String id = 'tripTodosScreen';

  @override
  _TripTodosScreenState createState() => _TripTodosScreenState();
}

class _TripTodosScreenState extends State<TripTodosScreen> {
  TextEditingController _editingController;
  String toDoContent = '';

  Column _buildBottomSheetMenu(BuildContext context, TripTodo tripTodo) {
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
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('Save'),
                        onPressed: () async {
                          final trips =
                              Provider.of<List<Trip>>(context, listen: false);
                          final tripIndex =
                              Provider.of<TripState>(context, listen: false)
                                  .selectedIndex;
                          final db = DatabaseService();

                          await db.updateTripTodoContent(
                              trips[tripIndex].id, tripTodo.id, toDoContent);

                          Navigator.pop(context);
                        },
                      )
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
            final db = DatabaseService();
            await db.deleteTripTodo(trips[tripIndex].id, tripTodo.id);
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
    final db = DatabaseService();
    final trips = Provider.of<List<Trip>>(context);
    final tripIndex = Provider.of<TripState>(context).selectedIndex;
    return StreamProvider<List<TripTodo>>.value(
      value: db.streamTripTodos(trips[tripIndex].id),
      child: Consumer<List<TripTodo>>(
        builder: (_, tripToDos, __) {
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
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text('Add'),
                                onPressed: () async {
                                  TripTodo tripTodo = TripTodo(
                                    content: toDoContent,
                                  );
                                  Navigator.pop(context);
                                  await db.addTodoToTrip(
                                      trips[tripIndex].id, tripTodo);
//                          Scaffold.of(context).showSnackBar(
//                            SnackBar(
//                              content: Text('ToDo Added.'),
//                            ),
//                          );
                                },
                              )
                            ],
                          );
                        });
                  },
                )
              ],
              title: Text('To Dos'),
            ),
            body: Column(
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
                                  await db.toggleTripTodoStatus(
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
                                              context, tripToDos[index]),
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
            ),
          ));
        },
      ),
    );
  }
}
