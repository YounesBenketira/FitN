import 'package:fit_k/Enums/workout.dart';
import 'package:flutter/material.dart';

import '../Logic/exercise.dart';

class CalendarPage extends StatefulWidget {
  Map<DateTime, List<Exercise>> dataSet;

  CalendarPage({Key key, this.dataSet}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    DateTime todaysDate = new DateTime(now.year, now.month, now.day);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              widget.dataSet[todaysDate].length.toString(),
              style: TextStyle(fontSize: 60),
            ),
            FlatButton(
              child: Text("Add Exercise"),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  widget.dataSet[todaysDate].add(
                    Exercise(workout: Workout.BentOverRow),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
