import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Future<QuerySnapshot> getUser(userid) async {
    QuerySnapshot data =
        await db.collection('users').where('userId', isEqualTo: userid).get();

    return data;
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

  Future<String> addFriend(String currentUserId, String? userId) async {
    try {
      print("Current User: $userId");
      print("Potential Friend: $currentUserId");

      //remove ids to sent and received
      await db.collection("users").doc(currentUserId).update({
        "receivedFriendRequests": FieldValue.arrayRemove([userId])
      });
      await db.collection("users").doc(userId).update({
        "sentFriendRequests": FieldValue.arrayRemove([currentUserId])
      });

      //add current user id to potential friend's received
      await db.collection("users").doc(userId).update({
        "friends": FieldValue.arrayUnion([currentUserId])
      });
      await db.collection("users").doc(currentUserId).update({
        "friends": FieldValue.arrayUnion([userId])
      });

      return "Successfully accepted request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteFriendRequest(
      String currentUserId, String? userId) async {
    try {
      print("Current User: $userId");
      print("To delete: $currentUserId");

      //add current user id to potential friend's received
      await db.collection("users").doc(userId).update({
        "sentFriendRequests": FieldValue.arrayRemove([currentUserId])
      });
      await db.collection("users").doc(currentUserId).update({
        "receivedFriendRequests": FieldValue.arrayRemove([userId])
      });

      return "Successfully deleted request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> unfriend(String currentUserId, String? userId) async {
    try {
      print("Current User: $userId");
      print("To delete: $currentUserId");

      //add current user id to potential friend's received
      await db.collection("users").doc(userId).update({
        "friends": FieldValue.arrayRemove([currentUserId])
      });
      await db.collection("users").doc(currentUserId).update({
        "friends": FieldValue.arrayRemove([userId])
      });

      return "Successfully unfriended!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
