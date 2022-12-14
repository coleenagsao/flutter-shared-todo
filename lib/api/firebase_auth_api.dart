import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  //final db = FakeFirebaseFirestore();

  // final auth = MockFirebaseAuth(
  //     mockUser: MockUser(
  //   isAnonymous: false,
  //   uid: 'someuid',
  //   email: 'charlie@paddyspub.com',
  //   displayName: 'Charlie',
  // ));

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  Future signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    }
  }

  void signOut() async {
    auth.signOut();
  }

  Future signUp(
      String email,
      String password,
      String fname,
      String lname,
      String uname,
      String bdate,
      String loc,
      String bio,
      List searchKeywords) async {
    UserCredential credential;

    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, fname, lname, uname,
            bdate, loc, bio, searchKeywords);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    }
  }

  void saveUserToFirestore(
      String? uid,
      String email,
      String fname,
      String lname,
      String uname,
      String bdate,
      String loc,
      String bio,
      List searchKeywords) async {
    try {
      await db.collection("users").doc(uid).set({
        "userId": uid,
        "email": email,
        "fname": fname,
        "lname": lname,
        "uname": uname,
        "bdate": bdate,
        "loc": loc,
        "bio": bio,
        "searchKeywords": searchKeywords,
        "friends": [],
        "receivedFriendRequests": [],
        "sentFriendRequests": []
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
