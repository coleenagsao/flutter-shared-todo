import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addTodo(Map<String, dynamic> todo) async {
    try {
      final docRef = await db.collection("todos").add(todo);
      await db.collection("todos").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllTodos() {
    return db.collection("todos").snapshots();
  }

  Future<String> deleteTodo(String? id) async {
    try {
      await db.collection("todos").doc(id).delete();

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editTodo(String? id, String title, String desc, String date,
      String time, String lastEditedBy, String lastEditedTimeStamp) async {
    try {
      print("New Title: $title");
      print("New Description: $desc");
      print("New Deadline: $date");
      print("New Deadline Time: $time");

      await db.collection("todos").doc(id).update({"title": title});
      await db.collection("todos").doc(id).update({"description": desc});
      await db.collection("todos").doc(id).update({"deadline": date});
      await db.collection("todos").doc(id).update({"deadlineTime": time});
      await db
          .collection("todos")
          .doc(id)
          .update({"lastEditedBy": lastEditedBy});
      await db
          .collection("todos")
          .doc(id)
          .update({"lastEditedTimeStamp": lastEditedTimeStamp});

      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> toggleStatus(String? id, bool status) async {
    try {
      await db.collection("todos").doc(id).update({"completed": status});

      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
