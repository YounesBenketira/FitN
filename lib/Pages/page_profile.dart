import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static DateTime now = new DateTime.now();
  DateTime todaysDate = new DateTime(now.year, now.month, now.day);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0, // has the effect of softening the shadow
                spreadRadius: 4, // has the effect of extending the shadow
                offset: Offset(
                  1.1, // horizontal, move right 10
                  4.0, // vertical, move down 10
                ),
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 65,
              ),
              Container(
                height: 40,
                width: 250,
                child: RaisedButton(
                  elevation: 10,
                  color: Colors.lightBlueAccent[400],
//                color: Colors.lightBlueAccent[100],
                  onPressed: () {},
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Container(
                height: 15,
              ),
              Container(
                height: 40,
                width: 250,
                child: RaisedButton(
                  elevation: 10,
                  color: Colors.redAccent[200],
                  onPressed: () {},
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
