import 'package:flutter/material.dart';

import '../exercise.dart';

class CalendarPage extends StatefulWidget {
  List<Exercise> dataSet;

  CalendarPage({Key key, this.dataSet}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
      child: Center(
        child: Text(
          widget.dataSet.length.toString(),
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
