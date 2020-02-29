import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  String content;

  Note({
    this.id,
    this.content,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Note(
      id: doc.documentID,
      content: data['content'],
    );
  }
}
