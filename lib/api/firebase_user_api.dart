import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Future<String> addFriendRequest(String currentUserId, String? userId) async {
    try {
      print("Current User: $userId");
      print("Potential Friend: $currentUserId");
      //add current user id to potential friend's received
      await db.collection("users").doc(userId).update({
        "receivedFriendRequests": FieldValue.arrayUnion([currentUserId])
      });

      //add the potentiall friend to the user's sent friend requests
      await db.collection("users").doc(currentUserId).update({
        "sentFriendRequests": FieldValue.arrayUnion([userId])
      });

      return "Successfully sent friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
