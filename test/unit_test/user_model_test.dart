import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

void main() {
  group("Todo Model", () {
    test('Test User Model constructor', () {
      final modelInstance = User(
        userId: "VRTRjh2FC1OWtIu4ghE6zh9nETm2",
        email: "cole@gmail.com",
        fname: "Cole",
        lname: "Ags",
        uname: "colecole",
        bdate: "12-07-2001",
        bio: "cs student here",
        loc: "Naga",
        searchKeywords: [],
        friends: [],
        receivedFriendRequests: [],
        sentFriendRequests: [],
      );

      expect(modelInstance.userId, "VRTRjh2FC1OWtIu4ghE6zh9nETm2");
      expect(modelInstance.email, "cole@gmail.com");
      expect(modelInstance.fname, "Cole");
      expect(modelInstance.lname, "Ags");
      expect(modelInstance.uname, "colecole");
      expect(modelInstance.bdate, "12-07-2001");
      expect(modelInstance.bio, "cs student here");
      expect(modelInstance.loc, "Naga");
      expect(modelInstance.friends, []);
      expect(modelInstance.receivedFriendRequests, []);
      expect(modelInstance.sentFriendRequests, []);
    });
  });
}
