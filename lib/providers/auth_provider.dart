import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      notifyListeners();
    }, onError: (e) {
      // print a more useful error
      // print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;

  String? get userId => userObj?.uid;

  bool get isAuthenticated {
    return user != null;
  }

  void signIn(String email, String password) {
    authService.signIn(email, password);
  }

  void signOut() {
    authService.signOut();
  }

  void signUp(String email, String password, String fname, String lname,
      String uname, String bdate, String loc, String bio, List searchKeywords) {
    authService.signUp(
        email, password, fname, lname, uname, bdate, loc, bio, searchKeywords);
  }
}
