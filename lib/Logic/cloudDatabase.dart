import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_k/Logic/profile.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // Collection Reference
  final CollectionReference profileDataCollection =
      Firestore.instance.collection('profileData');

  Future initalizeUserData(String first, String last, int exercisesDone) async {
    return await profileDataCollection.document(uid).setData({
      'firstName': first,
      'lastName': last,
      'exercisesDone': exercisesDone,
      'friendsList': List<Profile>(),
      'inbox': List(),
    });
  }

  void sendFriendRequest(Profile friend) async {
    Stream<Profile> friendsProfile = getUser(friend.profileID);
    friendsProfile.first.then((value) {
      List temp = value.inbox;

      Map inboxEntry = {"senderID": uid, "read": false, "FR": true};

      for (int i = 0; i < temp.length; i++) {
        if (temp.elementAt(i)["senderID"] == inboxEntry["senderID"]) {
          // if duplicate found!
//          print("duplicate found!");
          return;
        }
      }

//      print("Adding");

      temp.add({"senderID": uid, "read": false, "FR": true});

      profileDataCollection.document(friend.profileID).setData({
        'firstName': value.firstName,
        'lastName': value.lastName,
        'exercisesDone': value.exercisesDone,
        'friendsList': value.friends,
        'inbox': temp,
      });
    });
  }

  void removeFriendRequest(Profile friend) async {
    Stream<Profile> profile = currentUserProfileData;
    profile.first.then((value) {
      for (int i = 0; i < value.inbox.length; i++) {
        if (value.inbox.elementAt(i)['senderID'] == friend.profileID)
          value.inbox.removeAt(i);
        // Remove it
      }

      profileDataCollection.document(uid).updateData({
        'inbox': value.inbox,
      });
    });
  }

  void updateFriendsList(Profile friend, bool add) async {
    Stream<Profile> profile = currentUserProfileData;
    Profile data;
    profile.first.then((value) {
      data = value;
      if (add) {
        if (!data.friends.contains(friend.profileID)) {
          print("Adding Friend! ${friend.profileID}");
          data.friends.add(friend.profileID);
        }
      } else {
        if (data.friends.contains(friend.profileID)) {
          print("Removing Friend! ${friend.profileID}");
          data.friends.remove(friend.profileID);
        }
      }

      profileDataCollection.document(uid).setData({
        'firstName': data.firstName,
        'lastName': data.lastName,
        'exercisesDone': data.exercisesDone,
        'friendsList': data.friends,
        'inbox': data.inbox,
      });
    });
  }

  void updateExerciseCount(bool increment, int iterations) async {
    Stream<Profile> profile = currentUserProfileData;
    Profile data;
    profile.first.then((value) {
      data = value;
      int updatedExerciseCount;

      if (increment) {
        print("Incrementing Exercises Done $iterations");
        updatedExerciseCount = data.exercisesDone + iterations;
      } else {
        print("Decrementing Exercises Done $iterations");
        updatedExerciseCount = data.exercisesDone - iterations;

        if (updatedExerciseCount < 0) updatedExerciseCount = 0;
      }

      profileDataCollection.document(uid).setData({
        'firstName': data.firstName,
        'lastName': data.lastName,
        'exercisesDone': updatedExerciseCount,
        'friendsList': data.friends,
        'inbox': data.inbox,
      });
    });
  }

  List<Profile> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Profile(
        profileID: doc.documentID,
        firstName: doc.data['firstName'] ?? "",
        lastName: doc.data['lastName'] ?? "",
        exercisesDone: doc.data['exercisesDone'] ?? 0,
        friends: doc.data['friendsList'] ?? List<Profile>(),
        inbox: doc.data['inbox'] ?? List(),
      );
    }).toList();
  }

  Stream<Profile> getUser(String profileID) {
    return profileDataCollection.document(profileID).snapshots().map((entry) {
//      print(entry.documentID);
      return Profile(
        profileID: entry.documentID,
        firstName: entry.data['firstName'],
        lastName: entry.data['lastName'],
        exercisesDone: entry.data['exercisesDone'],
        friends: entry.data['friendsList'],
        inbox: entry.data['inbox'],
      );
    });
  }

  Stream<Profile> get currentUserProfileData {
    return profileDataCollection.document(uid).snapshots().map((entry) {
//      print(entry.documentID);
      return Profile(
        profileID: entry.documentID,
        firstName: entry.data['firstName'],
        lastName: entry.data['lastName'],
        exercisesDone: entry.data['exercisesDone'],
        friends: entry.data['friendsList'],
        inbox: entry.data['inbox'],
      );
    });
  }

  Stream<List<Profile>> get profileData {
    return profileDataCollection.snapshots().map(_profileListFromSnapshot);
  }
}
