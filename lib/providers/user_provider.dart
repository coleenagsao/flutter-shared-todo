import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/api/firebase_user_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class UserListProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _usersStream;
  User? _loggedInUser;

  UserListProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  // getter
  Stream<QuerySnapshot> get users => _usersStream;

  User get selected => _loggedInUser!;

  changeSelectedUser(User item) {
    _loggedInUser = item;
  }

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }
}
