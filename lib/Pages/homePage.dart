import 'package:fit_k/exercise.dart';
import 'package:fit_k/workout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<Exercise> dataSet;

  HomePage({Key key, this.dataSet}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.yellow,
      child: Column(children: <Widget>[
        Center(
          child: Text(
            widget.dataSet.length.toString(),
            style: TextStyle(fontSize: 60),
          ),
        ),
        FlatButton(
          child: Text("Add Set"),
          color: Colors.white,
          onPressed: () {
            setState(() {
              widget.dataSet.add(Exercise(workout: Workout.BentOverRow));
            });
          },
        ),
      ]),
    );
  }
}
