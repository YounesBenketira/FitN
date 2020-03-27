import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Enums/workout.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:fit_k/UI/ui_set.dart';
import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final Exercise exercise;

  String _title;
  List<Color> _theme = new List();

  CalendarCard({this.exercise}) {
    switch (this.exercise.workout) {
      case Workout.Bench:
        this._title = "Bench";
        break;
      case Workout.Squat:
        this._title = "Squat";
        break;
      case Workout.OverHeadPress:
        this._title = "OH Press";
        break;
      case Workout.BentOverRow:
        this._title = "BO Row";
        break;
      case Workout.Deadlift:
        this._title = "Deadlift";
        break;
    }

    // Dynamically set widget theme
    switch (this.exercise.theme) {
      case ColorTheme.Yellow:
        _theme.add(Colors.yellow[600]);
        _theme.add(Colors.yellow[700]);
        break;
      case ColorTheme.Blue:
        _theme.add(Colors.lightBlue[200]);
        _theme.add(Colors.lightBlue[500]);
        break;
      case ColorTheme.Purple:
        _theme.add(Colors.purpleAccent[200]);
        _theme.add(Colors.purpleAccent[700]);
        break;
      case ColorTheme.Peach:
        _theme.add(Colors.redAccent[100]);
        _theme.add(Colors.orangeAccent[700]);
        break;
      case ColorTheme.Green:
        _theme.add(Colors.greenAccent);
        _theme.add(Colors.greenAccent[700]);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SetUI_S> setList = List();

    for (int i = 0; i < exercise.setList.length; i++) {
//      print(exercise.setList['0'][0]);
      setList.add(SetUI_S(
          rep: exercise.setList[i.toString()][0],
          weight: exercise.setList[i.toString()][1]));
    }

    Widget _buildSetList() {
      return Positioned(
        top: 13,
        right: 40,
        left: 150,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              ...setList.map((entry) {
                return entry;
              }).toList(),
            ],
          ),
        ),
      );
    }

    Widget _buildCard() {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: _theme[0].withOpacity(0.9),
                  blurRadius: 8.0, // has the effect of softening the shadow
                  spreadRadius: 1, // has the effect of extending the shadow
                  offset: Offset(
                    1.1, // horizontal, move right 10
                    4.0, // vertical, move down 10
                  ),
                )
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _theme[0],
                  _theme[1],
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(70),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        _buildCard(),
        Positioned(
          left: 25,
          top: 20,
          child: Text(
            '$_title',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildSetList(),
      ],
    );
  }
}
