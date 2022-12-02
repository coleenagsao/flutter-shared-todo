import 'dart:convert';

class User {
  dynamic? userId;
  String email;
  String fname;
  String lname;
  String uname;
  String bdate;
  String loc;
  List friends;
  List receivedFriendRequests;
  List sentFriendRequests;

  User(
      {this.userId,
      required this.email,
      required this.fname,
      required this.lname,
      required this.uname,
      required this.bdate,
      required this.loc,
      required this.friends,
      required this.receivedFriendRequests,
      required this.sentFriendRequests});

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      email: json['email'],
      fname: json['fname'],
      lname: json['lname'],
      uname: json['uname'],
      bdate: json['bdate'],
      loc: json['loc'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequests: json['sentFriendRequests'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User todo) {
    return {
      'userId': todo.userId,
      'fname': todo.fname,
      'lname': todo.lname,
      'uname': todo.uname,
      'bdate': todo.bdate,
      'loc': todo.loc,
      'friends': todo.friends,
      'receivedFriendRequests': todo.receivedFriendRequests,
      'sentFriendRequests': todo.sentFriendRequests,
    };
  }
}