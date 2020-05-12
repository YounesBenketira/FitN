import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildProfileHeader(),
        _buildSubscriptionButton(),
        _buildRoutineButton(),
        _buildFriendsList(),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          Container(
            // Background
            width: double.infinity,
            height: 220,
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
                  'Younes Benketira',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'OpenSans'),
                ),
                Text(
                  '1560 Exercises Done',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                      fontFamily: 'OpenSans'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 197.5),
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
          )
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

  Widget _buildRoutineButton() {
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
    );
  }

  Widget _buildFriendsList() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Column(
        children: <Widget>[
          Text(
            'Friends List',
            style: TextStyle(
              fontSize: 27,
              color: Colors.grey[500],
              fontFamily: 'OpenSans',
            ),
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
                  height: 5,
                ),
//            Padding(
//              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//              child: Container(
//                width: double.infinity,
//                height: 1,
//                color: Colors.grey[600],
//              ),
//            ),
                Friend('Anthony Kumar'),
                Friend('Alexander David'),
                Container(
                  height: 15,
                ),
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

  Friend(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
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
              '200 Exercises',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}