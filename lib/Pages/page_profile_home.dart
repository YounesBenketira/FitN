import 'package:fit_k/Logic/auth.dart';
import 'package:fit_k/Logic/cloudDatabase.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:fit_k/Logic/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoggedInPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  LoggedInPage({this.auth, this.onSignedOut});

  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  Profile currentUser;

  List<Profile> friendsList = new List();

  @override
  void initState() {
    widget.auth.currentUserID().then((uid) {
      DatabaseService databaseService = DatabaseService(uid: uid);
      Stream<Profile> currentUserStream =
          databaseService.currentUserProfileData;
      currentUserStream.first.then((value) {
        setState(() {
          currentUser = value;
        });
      });
    });
    super.initState();
  }

  void _singedOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  void updateFriendsListUI(Profile friend, bool add) {
    if (add) {
      if (!friendsList.contains(friend)) {
        //print("Adding Friend to UI");
        setState(() {
          friendsList.add(friend);
        });

        final snackBar = SnackBar(
          content: Text(
            'Friend Added Successfully!',
//                            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        print("Friend Already Exists!");
        final snackBar = SnackBar(
          content: Text(
            'Friend already in your friends list!',
//                            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    } else {
      //print("Removing Friend from UI");
      setState(() {
        friendsList.remove(friend);
      });

      final snackBar = SnackBar(
        content: Text(
          'Friend Removed Successfully!',
//                            textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null)
      currentUser = Profile(
          firstName: '',
          lastName: '',
          exercisesDone: 0,
          friends: [],
          inbox: []);

    final profileList = Provider.of<List<Profile>>(context);

    if (friendsList.length == 0) {
      for (int i = 0; i < currentUser.friends.length; i++) {
        for (int k = 0; k < profileList.length; k++) {
          if (currentUser.friends[i] == profileList[k].profileID)
            friendsList.add(profileList[k]);
        }
      }
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _buildProfileHeader(context),
        _buildSubscriptionButton(),
        _buildRoutineButton(),
        _buildFriendsList(profileList),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      height: 280,
      child: Stack(
        children: <Widget>[
          Container(
            // Background
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff17EAD9),
                  Color(0xff6078EA),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 25,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('images/Backgrounds/bg2.jpg'),
                    radius: 45,
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    '${currentUser.firstName} ${currentUser.lastName}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'OpenSans'),
                  ),
                  Text(
                    '${currentUser.exercisesDone} Exercises Done',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                        fontFamily: 'OpenSans'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 237.5),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 150,
                child: RaisedButton(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                        fontSize: 17.5,
                        color: Colors.blueAccent,
                        fontFamily: 'OpenSans'),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Positioned(
            left: 10.0,
            top: 40.0,
            child: IconButton(
              icon: Icon(
                Icons.inbox,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
//                  elevation: 16,
                        child: Container(
                          width: double.infinity,
                          height: 450,
                          child: ListView(
                            children: [
                              Container(
                                height: 15,
                              ),
                              Center(
                                child: Text(
                                  'Inbox',
                                  style: TextStyle(
                                    fontSize: 27.5,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                              if (currentUser.inbox.length > 0)
                                ...currentUser.inbox.map((entry) {
                                  return InboxEntry(
                                      entry, currentUser, updateFriendsListUI);
                                }).toList()
                              else
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    width: double.infinity,
                                    height: 340,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey[400]),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Inbox is Empty!",
                                        style: TextStyle(
                                            fontFamily: "OpenSans",
                                            fontSize: 25,
                                            color: Colors.grey[400]),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          currentUser.inbox.length > 0
              ? Positioned(
                  left: 35,
                  top: 45,
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 20,
                  ),
                )
              : Container(),
          Positioned(
            right: 10.0,
            top: 40.0,
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                _singedOut();

                final snackBar = SnackBar(
                  content: Text(
                    'Logged Out Successfully',
//                            textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionButton() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15, right: 15, top: 12.5, bottom: 10),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5, // has the effect of softening the shadow
              spreadRadius: 1, // has the effect of extending the shadow
              offset: Offset(
                1.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 10),
                child: Image.asset("images/boxing.png"),
              ),
              Text(
                'Remove Ads',
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.grey[700],
                  fontFamily: 'OpenSans',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;

  Widget _buildRoutineButton() {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AddRoutineDialog();
            });
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 12.5, bottom: 10),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5, // has the effect of softening the shadow
                spreadRadius: 1, // has the effect of extending the shadow
                offset: Offset(
                  1.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Image.asset("images/Statistics/routine.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Add Workout Routine',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                      fontFamily: 'OpenSans',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsList(List profileList) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Friends List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    color: Colors.grey[700],
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AddFriendDialog(
                            profileList, updateFriendsListUI, currentUser);
                      });
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 22.5,
                    color: Colors.lightBlue,
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
//            color: Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 2,
                color: Colors.grey[300],
              ),
            ),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Container(
                  height: 15,
                ),
                if (friendsList.length == 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "Add Some Friends!",
                          style: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: 25,
                              color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  )
                else
                  ...friendsList.map((entry) {
                    return InkWell(
                      onTap: () {
                        // Show Friend Details
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
//                  elevation: 16,
                                  child: Container(
                                    width: double.infinity,
                                    height: 180,
                                    child: ListView(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  top: 20,
                                                  right: 15,
                                                  bottom: 20),
                                              child: CircleAvatar(
                                                // @TODO dynamic profile pictures
                                                backgroundImage: AssetImage(
                                                    'images/Backgrounds/bg1.jpg'),
                                                radius: 40,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  height: 5,
                                                ),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 200,
                                                  ),
//                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "${entry.firstName} ${entry.lastName}",
                                                    style: TextStyle(
                                                      fontFamily: "OpenSans",
                                                      fontSize: 22.5,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${entry.exercisesDone} exercises done",
                                                  style: TextStyle(
                                                    fontFamily: "OpenSans",
                                                    fontSize: 17.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "View Friends",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                print("View Friends Pressed");
                                              },
                                              color: Colors.lightBlueAccent,
                                            ),
                                            FlatButton(
                                              child: Text(
                                                "Remove Friend",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                DatabaseService(
                                                        uid: currentUser
                                                            .profileID)
                                                    .updateFriendsList(
                                                        entry, false);
                                                updateFriendsListUI(
                                                    entry, false);
                                                Navigator.of(context).pop();
                                              },
                                              color: Colors.redAccent,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                        ),
                                      ],
                                    ),
                                  ));
                            });
                      },
                      child: Friend("${entry.firstName} ${entry.lastName}",
                          entry.exercisesDone),
                    );
                  }).toList(),
//                Friend('Anthony Kumar', 200),
//                Friend('Alexander David', 299),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Friend extends StatelessWidget {
  final String name;
  final int exerciseCount;

  Friend(this.name, this.exerciseCount);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15),
      child: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2, // has the effect of softening the shadow
                    spreadRadius: 1, // has the effect of extending the shadow
                    offset: Offset(
                      1.0, // horizontal, move right 10
                      1.0, // vertical, move down 10
                    ),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(5)),
              )),
          Positioned(
            left: 5,
            top: 5,
            child: CircleAvatar(
//              width: 50,
//              height: 50,
//              decoration: BoxDecoration(
//                color: Colors.deepPurple,
//                shape: BoxShape.circle
//              ),
//            borderRadius: ,
              backgroundImage: AssetImage('images/Backgrounds/bg1.jpg'),
              radius: 25,
            ),
          ),
          Positioned(
            left: 62.5,
            top: 7,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 17.5,
                color: Colors.black87,
                fontFamily: 'OpenSans-Bold',
              ),
            ),
          ),
          Positioned(
            left: 62,
            top: 34,
            child: Text(
              '$exerciseCount Exercises',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class AddFriendDialog extends StatefulWidget {
  final List<Profile> profileList;
  final Function updateFriendsListUI;
  final Profile currentUser;

  AddFriendDialog(this.profileList, this.updateFriendsListUI, this.currentUser);

  @override
  _AddFriendDialogState createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  List<Profile> temp = new List();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                  elevation: 16,
        child: Container(
          width: double.infinity,
          height: 450,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  child: Text(
                    "Add Friend",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 25,
                        color: Colors.grey[800]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Container(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for friend",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onChanged: (text) {
                      if (text.length == 0) {
//                        print("empty Search");
                        setState(() {
                          temp = new List();
                        });
                        return;
                      }

//                      print("Running Comparison");
                      for (int i = 0; i < widget.profileList.length; i++) {
                        String fullName =
                            "${widget.profileList[i].firstName} ${widget.profileList[i].lastName}"
                                .toLowerCase();
                        if (fullName.contains(text.toLowerCase())) {
                          setState(() {
                            if (!temp.contains(widget.profileList[i]))
                              temp.add(widget.profileList[i]);
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
              ...temp.map((entry) {
                return Stack(
                  children: [
                    Friend("${entry.firstName} ${entry.lastName}",
                        entry.exercisesDone),
                    Positioned(
                      top: 5,
                      right: 25,
                      child: Container(
                        width: 70,
                        child: RaisedButton(
                          color: Colors.lightBlueAccent,
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "OpenSans",
                            ),
                          ),
                          onPressed: () {
                            DatabaseService(uid: widget.currentUser.profileID)
                                .sendFriendRequest(entry);

//                                        print(entry);
//                            widget.updateFriendsListUI(entry, true);

                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ));
  }
}

class InboxEntry extends StatefulWidget {
  final Map inboxData;
  final Profile currentUser;
  final Function updateFriendsListUI;

  InboxEntry(
    this.inboxData,
    this.currentUser,
    this.updateFriendsListUI,
  );

  @override
  _InboxEntryState createState() => _InboxEntryState();
}

class _InboxEntryState extends State<InboxEntry> {
  String label = " ";
  bool showButtons;
  Profile senderProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.inboxData["senderID"] != null) {
      Stream<Profile> friendReqSender =
          DatabaseService(uid: widget.currentUser.profileID)
              .getUser(widget.inboxData["senderID"]);

      friendReqSender.first.then((value) {
        senderProfile = value;
        setState(() {
          label = "${value.firstName} ${value.lastName}";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 12.5, right: 12.5),
          child: Container(
            width: double.infinity,
            height: 80,
//                                    color: Colors.red,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5, // has the effect of softening the shadow
                  spreadRadius: 2, // has the effect of extending the shadow
                  offset: Offset(
                    1.0, // horizontal, move right 10
                    2.0, // vertical, move down 10
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('images/Backgrounds/bg2.jpg'),
                    radius: 30,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 8),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 55,
          right: 50,
          child: Row(
            children: [
              Container(
                height: 25,
                child: FlatButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    DatabaseService(uid: widget.currentUser.profileID)
                        .removeFriendRequest(senderProfile);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Deny",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 10,
              ),
              Container(
                height: 25,
                child: FlatButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    DatabaseService databaseService =
                        DatabaseService(uid: widget.currentUser.profileID);

                    databaseService.updateFriendsList(senderProfile, true);
                    widget.updateFriendsListUI(senderProfile, true);
                    databaseService.removeFriendRequest(senderProfile);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Accept",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 25,
          child: Container(
            height: 22,
            width: 120,
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5, // has the effect of softening the shadow
                    spreadRadius: 1, // has the effect of extending the shadow
                    offset: Offset(
                      1.0, // horizontal, move right 10
                      2.0, // vertical, move down 10
                    ),
                  )
                ]),
            child: Text(
              "Friend Request",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "OpenSans", fontSize: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class AddRoutineDialog extends StatefulWidget {
  List<RoutineWeekdayButton> _buttonList = [
    RoutineWeekdayButton(false, "S"),
    RoutineWeekdayButton(false, "M"),
    RoutineWeekdayButton(false, "T"),
    RoutineWeekdayButton(false, "W"),
    RoutineWeekdayButton(false, "T"),
    RoutineWeekdayButton(false, "F"),
    RoutineWeekdayButton(false, "S"),
  ];

  List<Exercise> _excerciseList = [];

  @override
  _AddRoutineDialogState createState() => _AddRoutineDialogState();
}

class _AddRoutineDialogState extends State<AddRoutineDialog> {


  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                  elevation: 16,
        child: Container(
          width: double.infinity,
          height: 400,
          child: ListView(
            children: <Widget>[
              Container(
                height: 20,
              ),
              Center(
                child: Text(
                  "Add Routine",
                  style: TextStyle(fontFamily: "OpenSans", fontSize: 25.0),
                ),
              ),
              Container(
                height: 20,
              ),
              Row(
                children: [
                  ...widget._buttonList,
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                child: Container(
                  decoration: BoxDecoration(
//            color: Colors.pink,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey[300],
                    ),
                  ),
                  height: 200,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15.0, top: 10.0, left: 15.0, right: 15.0),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          child: FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(20)),
                                          child: Container(
                                            width: double.infinity,
                                            height: 200,
                                            child: Text(
                                                "Swag"
                                            ),)
                                      );
                                    });
                              },
                              color: Colors.grey[300],
                              child: Text(
                                "Add Workout",
                                style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: 23,
                                    color: Colors.grey[500]),
                              )),
                        ),
                      ),
//                Friend('Anthony Kumar', 200),
//                Friend('Alexander David', 299),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 237.5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 150,
                    child: RaisedButton(
                      color: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
//                side: BorderSide(color: Colors.red)
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontSize: 17.5,
                            color: Colors.blueAccent,
                            fontFamily: 'OpenSans'),
                      ),
                      onPressed: () {
                        for (int i = 0; i < widget._buttonList.length; i++) {
                          print(widget._buttonList[i].label +
                              " " +
                              widget._buttonList[i].selected.toString());
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class RoutineWeekdayButton extends StatefulWidget {
  bool selected;
  String label;

  RoutineWeekdayButton(this.selected, this.label);

  @override
  _RoutineWeekdayButtonState createState() => _RoutineWeekdayButtonState();
}

class _RoutineWeekdayButtonState extends State<RoutineWeekdayButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        width: 35,
        height: 30,
        child: RaisedButton(
          elevation: 0,
          color: widget.selected ? Colors.lightBlue : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side:
            BorderSide(color: widget.selected ? Colors.white : Colors.grey),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12.5,
              color: widget.selected ? Colors.white : Colors.black54,
              fontFamily: 'OpenSans',
            ),
          ),
          onPressed: () {
//                print(selected);
//                print(sunday);
            setState(() {
              widget.selected = !widget.selected;
            });
          },
        ),
      ),
    );
  }
}
