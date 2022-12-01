import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/api/firebase_user_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class UserListProvider with ChangeNotifier {
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _usersStream;
  User? _loggedInUser;

  UserListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchUsers();
  }

  // getter
  Stream<QuerySnapshot> get users => _usersStream;

  User get selected => _loggedInUser!;

  changeSelectedTodo(User item) {
    _loggedInUser = item;
  }

  Future<QuerySnapshot> getCurrentUser(userId) {
    return firebaseService.getCurrentUser(userId);
  }

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }
}
