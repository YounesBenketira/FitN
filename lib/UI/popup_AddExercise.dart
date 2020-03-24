import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Enums/workout.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseCreationPopup extends StatefulWidget {
  List<dynamic> exerciseList;
  Function addExercise;

  ExerciseCreationPopup({this.exerciseList, this.addExercise});

  @override
  _ExcerciseDialogueAdd createState() => _ExcerciseDialogueAdd();
}

class _ExcerciseDialogueAdd extends State<ExerciseCreationPopup> {
  List workoutList = Workout.values;
  List colorList = ColorTheme.values;

  List<DropdownMenuItem<Workout>> _workoutMenuItems;
  Workout _selectedWorkout;

  List<DropdownMenuItem<ColorTheme>> _colorMenuItems;
  ColorTheme _selectedColor;

  List<DropdownMenuItem<Workout>> _buildWorkoutMenuItems(List workouts) {
    List<DropdownMenuItem<Workout>> list = new List();
    for (Workout workout in workouts) {
      String label = workout.toString().substring(8);
      list.add(DropdownMenuItem(
        value: workout,
        child: Text(label),
      ));
    }

    return list;
  }

  List<DropdownMenuItem<ColorTheme>> _buildColorMenuItems(List colors) {
    List<DropdownMenuItem<ColorTheme>> list = new List();
    for (ColorTheme color in colors) {
      MaterialColor clr;
      switch (color) {
        case ColorTheme.Yellow:
          clr = Colors.yellow;
          break;
        case ColorTheme.Blue:
          clr = Colors.blue;
          break;
        case ColorTheme.Purple:
          clr = Colors.purple;
          break;
        case ColorTheme.Peach:
          clr = Colors.orange;
          break;
        case ColorTheme.Green:
          clr = Colors.green;
          break;
      }

      list.add(DropdownMenuItem(
        value: color,
        child: Container(
          color: clr,
          width: 50,
          height: 20,
        ),
      ));
    }

    return list;
  }

  void changeWorkout(Workout selectedWorkout) {
    setState(() {
      _selectedWorkout = selectedWorkout;
    });
  }

  void changeColor(ColorTheme selectedColor) {
    setState(() {
      _selectedColor = selectedColor;
    });
  }


  @override
  void initState() {
    _workoutMenuItems = _buildWorkoutMenuItems(workoutList);
    _selectedWorkout = workoutList[0];

    _colorMenuItems = _buildColorMenuItems(colorList);
    _selectedColor = colorList[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: Container(
        height: 300.0,
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Container(
                width: 100,
                height: 30,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.contain,
                  child: Text(
                    "Workout: ",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton(
                value: _selectedWorkout,
                items: _workoutMenuItems,
                onChanged: changeWorkout,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Container(
                width: 90,
                height: 30,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.contain,
                  child: Text(
                    "Color: ",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: 20,
              ),
              Container(
//            height: 40,
                color: Colors.white10,
                child: DropdownButton(
                  value: _selectedColor,
                  items: _colorMenuItems,
                  onChanged: changeColor,
                ),
              ),
            ],
          ),
          Row(children: <Widget>[
            Container(
              width: 20,
            ),
            Expanded(
              child: RaisedButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
            Container(
              width: 20,
            ),
            Expanded(
              child: RaisedButton(
                  color: Colors.lightBlueAccent[200],
                  onPressed: () {
                    Workout workout = _selectedWorkout;
                    ColorTheme theme = _selectedColor;
                    setState(() {
                      widget.addExercise(Exercise(
                        id: widget.exerciseList.length,
                        workout: workout,
                        theme: theme,
                      ));
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
            Container(
              width: 20,
            ),
          ]),
        ]),
      ),
    );
  }
}
