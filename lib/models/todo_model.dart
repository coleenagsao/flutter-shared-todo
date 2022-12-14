/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'dart:convert';

class Todo {
  final dynamic userId;
  String? id;
  String title;
  String? desc;
  String? deadline;
  bool completed;
  List? notifications;
  String? lastEditedBy;
  String? lastEditedTimeStamp;

  Todo({
    required this.userId,
    this.id,
    required this.title,
    this.desc,
    this.deadline,
    this.notifications,
    required this.completed,
  });

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      deadline: json['deadline'],
      completed: json['completed'],
      notifications: json['notifications'],
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'userId': todo.userId,
      'title': todo.title,
      'description': todo.desc,
      'completed': todo.completed,
      'deadline': todo.deadline,
      'notifications': todo.notifications
    };
  }
}
