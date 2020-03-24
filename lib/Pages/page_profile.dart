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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green,
      child: Center(
        child: Text(
          "Profile",
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
