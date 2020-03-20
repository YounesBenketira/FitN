import 'package:fit_k/exercise.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  List<Exercise> dataSet;

  ProfilePage({Key key, this.dataSet}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green,
      child: Center(
        child: Text(
          widget.dataSet.length.toString(),
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
