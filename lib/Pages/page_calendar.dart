
import 'package:fit_k/Logic/controller_data.dart';

import 'package:flutter/material.dart';


import '../Logic/exercise.dart';

class CalendarPage extends StatefulWidget {
  Map<DateTime, List<Exercise>> dataSet;

  CalendarPage({Key key, this.dataSet}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Map> jsonSwagger;

  @override
  void initState() {
    DateTime now = new DateTime.now();
    DateTime todaysDate = new DateTime(now.year, now.month, now.day);

    jsonSwagger = [
      {'date':todaysDate.toIso8601String(), 'exercises': widget.dataSet[todaysDate]},
      {'date':todaysDate.subtract(Duration(days: 1)).toIso8601String(), 'exercises':  widget.dataSet[todaysDate]},
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              color: Colors.greenAccent,
              child: Text("Save"),
              onPressed: () async {
                DataController dataController = DataController.instance;
                dataController.writeContent(jsonSwagger);
              },
            ),
            FlatButton(
              color: Colors.redAccent,
              child: Text("Read"),
              onPressed: () {
                DataController dataController = DataController.instance;
                dataController.readcontent().then((String value){
                  print(value);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
