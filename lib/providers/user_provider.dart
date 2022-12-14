import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/api/firebase_user_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class UserListProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _usersStream;
  User? _loggedInUser;
  User? _selectedUser;

  UserListProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  // getter
  Stream<QuerySnapshot> get users => _usersStream;
  // Stream<QuerySnapshot> get user() => _userStream;

  User get selected => _loggedInUser!;
  User get selectedFriend => _selectedUser!;

  changeSelectedUser(User item) {
    _loggedInUser = item;
  }

  changeSelectedFriend(User item) {
    _selectedUser = item;
  }

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  // void fetchUser(String userId) async {
  //   _usersStream = await firebaseService.getUser(userId);
  //   notifyListeners();
  // }

  void addFriendRequest(String currentUserId) async {
    String message = await firebaseService.addFriendRequest(
        currentUserId, _loggedInUser!.userId);
    print(message);
    notifyListeners();
  }

  void addFriend(String currentUserId) async {
    String message =
        await firebaseService.addFriend(currentUserId, _loggedInUser!.userId);
    print(message);
    notifyListeners();
  }

  void deleteFriendRequest(String currentUserId) async {
    String message = await firebaseService.deleteFriendRequest(
        currentUserId, _loggedInUser!.userId);
    print(message);
    notifyListeners();
  }

  void unfriend(String currentUserId) async {
    String message =
        await firebaseService.unfriend(currentUserId, _loggedInUser!.userId);
    print(message);
    notifyListeners();
  }
}
