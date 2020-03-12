import 'package:cloud_firestore/cloud_firestore.dart';

class TripTodo {
  final String id;
  final String content;
  final bool isFinished;

  TripTodo({
    this.id,
    this.content,
    this.isFinished,
  });

  factory TripTodo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return TripTodo(
      id: doc.documentID,
      content: data['content'],
      isFinished: data['isFinished'],
    );
  }
}
