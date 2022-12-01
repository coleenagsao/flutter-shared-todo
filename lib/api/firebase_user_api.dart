import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTodoAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Future<QuerySnapshot> getCurrentUser(userId) async {
    return db.collection('users').where("userId", isEqualTo: userId).get();
  }
}
