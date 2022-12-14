import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';

void main() {
  group("Todo Model", () {
    test('Test Todo Model constructor', () {
      final modelInstance = Todo(
          userId: 1,
          title: "Test Todo",
          description: "Desc1",
          deadline: "12-07-2012",
          deadlineTime: "09:07 AM",
          completed: false,
          notifications: [],
          lastEditedBy: "VRTRjh2FC1OWtIu4ghE6zh9nETm2",
          lastEditedTimeStamp: "2022-12-14 17:33:31.986");

      expect(modelInstance.userId, 1);
      expect(modelInstance.description, "Desc1");
      expect(modelInstance.title, "Test Todo");
      expect(modelInstance.deadline, "12-07-2012");
      expect(modelInstance.deadlineTime, "09:07 AM");
      expect(modelInstance.completed, false);
      expect(modelInstance.lastEditedTimeStamp, "VRTRjh2FC1OWtIu4ghE6zh9nETm2");
      expect(modelInstance.lastEditedTimeStamp, "2022-12-14 17:33:31.986");
    });

    test('Test Todo Model toJson method', () {
      final modelInstance = Todo(
          userId: 1,
          title: "Test Todo",
          description: "Desc1",
          deadline: "12-07-2012",
          deadlineTime: "09:07 AM",
          completed: false,
          notifications: [],
          lastEditedBy: "VRTRjh2FC1OWtIu4ghE6zh9nETm2",
          lastEditedTimeStamp: "2022-12-14 17:33:31.986");

      // do something
      final converted = modelInstance.toJson(modelInstance);

      //test the actual vs the expected
      expect(converted, {
        "userId": 1,
        "title": "Test Todo",
        "description": "Desc1",
        "deadline": "12-07-2012",
        "deadlineTime": "09:07 AM",
        "completed": false,
        "notifications": [],
        "lastEditedBy": "VRTRjh2FC1OWtIu4ghE6zh9nETm2",
        "lastEditedTimeStamp": "2022-12-14 17:33:31.986"
      });
    });
  });
}
