/*
  Base Code Used:
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';

class TodoModal extends StatelessWidget {
  String type;
  // int todoIndex;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  TodoModal({
    super.key,
    required this.type,
  });

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
          );
        }
      case 'Edit':
        {
          titleController.text =
              '${context.read<TodoListProvider>().selected.title}';
          descController.text =
              '${context.read<TodoListProvider>().selected.description}';
          dateController.text =
              '${context.read<TodoListProvider>().selected.deadline}';
          timeController.text =
              '${context.read<TodoListProvider>().selected.deadlineTime}';

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Enter task title",
                  ),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Enter task description",
                  ),
                ),
                TextField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: "Deadine Date",
                      hintText: "Enter task deadline date",
                    ),
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      dateController.text = date.toString().substring(0, 10);
                    }),
                TextField(
                    readOnly: true,
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: "Deadline Time",
                      hintText: "Enter task deadline time",
                    ),
                    onTap: () async {
                      var time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      timeController.text =
                          time == null ? "" : time.format(context);
                    }),
                Text(" "),
                Text(
                    "Last Edited User with userid:'${context.read<TodoListProvider>().selected.lastEditedBy}'?",
                    style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                Text(
                    "Last Edited TimeStamp:'${context.read<TodoListProvider>().selected.lastEditedTimeStamp}'?",
                    style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ]);
        }
      // Add will have input field in them
      default:
        return Column(children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
              hintText: "Enter task title",
            ),
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(
              labelText: "Description",
              hintText: "Enter task description",
            ),
          ),
          TextField(
              readOnly: true,
              controller: dateController,
              decoration: InputDecoration(
                labelText: "Deadine Date",
                hintText: "Enter task deadline date",
              ),
              onTap: () async {
                var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                dateController.text = date.toString().substring(0, 10);
              }),
          TextField(
              readOnly: true,
              controller: timeController,
              decoration: InputDecoration(
                labelText: "Deadline Time",
                hintText: "Enter task deadline time",
              ),
              onTap: () async {
                var time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                timeController.text = time == null ? "" : time.format(context);
              })
        ]);
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              // Instantiate a todo objeect to be inserted, default userID will be 1, the id will beEthe next id in the list
              Todo temp = Todo(
                  userId: Provider.of<AuthProvider>(context, listen: false)
                      .userId
                      .toString(),
                  // context.watch<AuthProvider>().userId.toString(),
                  completed: false,
                  title: titleController.text,
                  description: descController.text,
                  deadline: dateController.text,
                  deadlineTime: timeController.text,
                  lastEditedBy:
                      Provider.of<AuthProvider>(context, listen: false)
                          .userId
                          .toString(),
                  lastEditedTimeStamp: DateTime.now().toString(),
                  notifications: []);

              context.read<TodoListProvider>().addTodo(temp);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              String lastEditedTimeStamp = DateTime.now().toString();
              String? lastEditedBy =
                  Provider.of<AuthProvider>(context, listen: false)
                      .userId
                      .toString();
              context.read<TodoListProvider>().editTodo(
                    titleController.text,
                    descController.text,
                    dateController.text,
                    timeController.text,
                    lastEditedBy.toString(),
                    lastEditedTimeStamp,
                  );

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
