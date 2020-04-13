import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Enums/workout.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseCreator extends StatefulWidget {
  Function addExercise;

  ExerciseCreator({Key key, this.addExercise}) : super(key: key);

  @override
  _ExerciseCreatorState createState() => _ExerciseCreatorState();
}

class _ExerciseCreatorState extends State<ExerciseCreator> {
  static List shoulders = [
    'Arnold Dumbbell Press',
    'Overhead Press',
    'Seated Dumbbell Press',
    'Log Press',
    'Standing Dumbbell Press',
    'Push Press',
    'Front Dumbbell Raise',
    'Lateral Raise',
    'Rear Delt Dumbbell Raise',
    'Face Pull',
    'Rear Delt Fly',
  ];

  static List triceps = [
    "Triceps Extension",
    "Close Grip Bench Press",
    "Overhead Triceps Extension",
    "Skullcrusher",
    "Triceps Dip",
    "Rope PushDown",
    "VBar PushDown"
  ];

  static List biceps = [
    "Barbell Curl",
    "Cable Curl",
    "Dumbbell Curl",
    "Concentration Curl",
    "Hammer Curl",
    "Preacher Curl",
    "Incline Dumbbell Curl",
    "Machine Curl",
  ];

  static List chest = [
    "Cable Crossover",
    "Decline Bench Press",
    "Bench Press",
    "Dumbbell Fly",
    "Incline Bench Press",
    "Incline Dumbbell Fly",
    "Machine Fly",
  ];

  static List back = [
    "Barbell Row",
    "Barbell Shrug",
    "Dumbbell Shrug",
    "Chin Up",
    "Deadlift",
    "Dumbbell Row",
    "Good Morning",
    "Hammer-Strength Row",
    "LatPulldown",
    "Pendlay Row",
    "Pull Up",
    'Rack Pull',
    'Seated Cable Row',
    'Cable Pushdown',
  ];

  static List legs = [
    'Barbell Front Squat',
    'Barbell Glute Bridge',
    'Barbell Squat',
    'Donkey Calf Raise',
    'Glute Ham Raise',
    'Leg Extension',
    'Leg Press',
    'Leg Curl',
    'Romanian Deadlift',
    'Seated Calf Raise',
    'Standing Calf Raise',
    'Stiff Legged Deadlift',
    'Sumo Deadlift',
  ];

  static List abs = [
    'Ab-Wheel Rollout',
    'Cable Crunch',
    'Crunch',
    'Decline Crunch',
    'Dragon Flag',
    'Hanging Knee Raise',
    'Hanging Leg Raise',
    'Plank',
    'Side Plank',
  ];

  static List cardio = [
    'Cycling',
    'Elliptical',
    'Rowing Machine',
    'Running',
    'Bike',
    'Swimming',
    'Walking',
  ];

  static List<Map> data = [
    {'Category': 'Shoulders', 'Exercises': shoulders},
    {'Category': 'Triceps', 'Exercises': triceps},
    {'Category': 'Biceps', 'Exercises': biceps},
    {'Category': 'Chest', 'Exercises': chest},
    {'Category': 'Back', 'Exercises': back},
    {'Category': 'Legs', 'Exercises': legs},
    {'Category': 'Abs', 'Exercises': abs},
    {'Category': 'Cardio', 'Exercises': cardio},
  ];

  List categories = [
    'Shoulders',
    'Triceps',
    'Biceps',
    'Chest',
    'Back',
    'Legs',
    'Abs',
    'Cardio'
  ];

  List colors = [
    [
      Color(0xff17EAD9),
      Color(0xff6078EA),
    ],
    [
      Color(0xffFCE043),
      Color(0xffFB7BA2),
    ],
    [
      Color(0xff42E695),
      Color(0xff3BB2B8),
    ],
    [
      Color(0xfffa71cd),
      Color(0xffc471f5),
    ],
//    [
//      Color(0xffDD2476),
//      Color(0xffFF512F),
//    ],
  ];

  List allExercises = List();
  List displayData;
  String _title;
  int _index = 0;

  @override
  void initState() {
    for (int i = 0; i < data.length; i++)
      allExercises.addAll(data[i]['Exercises']);

    displayData = categories;

    _title = 'Select Category';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
//        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            setState(() {
              _index--;
              _changeList(displayData);
//              print(_index);
            });
          },
        ),
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            _title,
            style: TextStyle(
              fontSize: 35,
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
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
                  _index = 1;
                  if (text != '') {
                    displayData = allExercises.where((entry) {
                      return entry.toLowerCase().contains(text);
                    }).toList();
                    _title = 'Select Exercise';
                  } else {
                    displayData = categories;
                    _index = 0;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Exercise',
              ),
            ),
          ),
          _buildList(displayData),
        ],
      ),
    );
  }

  Workout selectedWorkout;
  bool workoutNotSet = true;
  ColorTheme selectedColor;
  String selectedExercise;

  void _changeList(var selected) {
    switch (_index) {
      case -1: // Show Category
        Navigator.of(context).pop();
        break;
      case 0: // Show Category
        setState(() {
          displayData = categories;
          _title = 'Select Category';
        });
        break;
      case 1: // Show Exercise List
        if (selected is String) {
          selectedExercise = selected;
          for (int i = 0; i < data.length; i++) {
            if (data[i]['Category'] == selectedExercise) {
              setState(() {
                displayData = data[i]['Exercises'];
                _title = 'Select Exercise';
              });
              return;
            }
          }
        } else if (selected is List) {
          if (selectedExercise == null) {
            setState(() {
              displayData = categories;
              _title = 'Select Category';
            });
            _index = 0;
          } else {
            for (int i = 0; i < data.length; i++) {
              if (data[i]['Category'] == selectedExercise) {
                setState(() {
                  displayData = data[i]['Exercises'];
                  _title = 'Select Exercise';
                });
                return;
              }
            }
          }
        }
        break;
      case 2: // Show Colors
        if (selected is! List)
          selectedWorkout = Workout.values.firstWhere(
              (e) => e.toString().substring(8) == selected.replaceAll(' ', ''));
        setState(() {
          displayData = colors;
          _title = 'Select Color';
        });
        break;
      case 3: // Create Exercise and change screens
        List temp = selected;
        if (temp[0] == Color(0xff17EAD9)) // yellow
          selectedColor = ColorTheme.Blue;
        else if (temp[0] == Color(0xffFCE043)) // blue
          selectedColor = ColorTheme.Peach;
        else if (temp[0] == Color(0xff42E695)) // purple
          selectedColor = ColorTheme.Green;
        else if (temp[0] == Color(0xfffa71cd)) // peach
          selectedColor = ColorTheme.Pink;
//        else if (temp[0] == Color(0xffDD2476)) // green
//          selectedColor = ColorTheme.Yellow;

        Exercise exercise =
            Exercise(workout: selectedWorkout, theme: selectedColor);

        widget.addExercise(exercise);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (_) => false,
        );
        break;
    }
  }

  Widget _buildList(List display) {
    return Column(
      children: <Widget>[
        ...display.map((entry) {
//          print(entry);
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Container(
              width: double.infinity,
              child: FlatButton(
//                elevation: 2,
//              color: Colors.blue,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: entry is String
                      ? FittedBox(
                    child: Text(
                      entry,
                      style:
                      TextStyle(fontSize: 20, fontFamily: "OpenSans"),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
//                  color: widget._theme[0].withOpacity(0.9),
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 5.0,
                            // has the effect of softening the shadow
                            spreadRadius: 3,
                            // has the effect of extending the shadow
                            offset: Offset(
                              2.0, // horizontal, move right 10
                              4.0, // vertical, move down 10
                            ),
                          )
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            entry[0],
                            entry[1],
                          ],
//                              colors: entry,
                        ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                    width: double.infinity,
                    height: 35,
                  ),
                ),
                onPressed: () {
                  _index++;
                  _changeList(entry);
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
