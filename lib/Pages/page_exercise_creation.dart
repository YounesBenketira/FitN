import 'package:flutter/material.dart';

class ExerciseCreator extends StatefulWidget {
  ExerciseCreator({Key key}) : super(key: key);

  @override
  _ExerciseCreatorState createState() => _ExerciseCreatorState();
}

class _ExerciseCreatorState extends State<ExerciseCreator> {
  static List shoulders = [
    'Arnold Dumbbell Press',
    'Behind The Neck Barbell Press',
    'Cable Face Pull',
    'Front Dumbbell Raise',
    'Hammer Strength Shoulder Press',
    'Lateral Dumbbell Raise',
    'Lateral Machine Raise',
    'Log Press',
    'One-Arm Standing Dumbbell Press',
    'Overhead Press',
    'Push Press',
    'Rear Delt Dumbbell Raise',
    'Rear Delt Machine Fly',
    'Seated Dumbbell Lateral Raise',
    'Seated Dumbbell Press',
    'Smith Machine Overhead Press',
  ];

  static List<Map> data = [
    {'Shoulders': shoulders},
    {'Triceps': []},
    {'Biceps': []},
    {'Chest': []},
    {'Back': []},
    {'Legs': []},
    {'Abs': []},
    {'Cardio': []},
  ];

  List displayData = data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Select Exercise',
          style: TextStyle(
            fontSize: 45,
            color: Colors.black,
            fontFamily: 'ShareTech',
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  displayData = data.where((entry) {
                    var entryName =
                        entry.keys.elementAt(0).toString().toLowerCase();
                    return entryName.contains(text);
                  }).toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Exercise',
              ),
            ),
          ),
          ListHolder(
            data: displayData,
          ),
        ],
      ),
    );
  }
}

class ListHolder extends StatelessWidget {
  var data;

  ListHolder({this.data});

  @override
  Widget build(BuildContext context) {
    Widget widget;
    data is List
        ? widget = Column(
            children: <Widget>[
              ...data.map((entry) {
                return Container(
                  width: double.infinity,
//                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      entry.keys.elementAt(0).toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                );
              }).toList(),
            ],
          )
        : widget = Container();

    return widget;
  }
}
