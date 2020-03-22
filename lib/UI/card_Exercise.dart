import 'package:fit_k/Enums/cardTheme.dart';
import 'package:flutter/material.dart';

import '../Enums/workout.dart';
import '../Logic/exercise.dart';
//import 'package:fit_k/Enums/cardTheme.dart';

class ExerciseCard extends StatefulWidget {
  Exercise exercise;

  String _title;
  List<Color> _theme = new List();
  Image _icon;

  Function deleteExercise;
  Function updateSets;

  ExerciseCard({this.exercise, this.deleteExercise, this.updateSets}) {
    // Dynamically set widget header
    switch (this.exercise.workout) {
      case Workout.Bench:
        this._title = "Bench";
        this._icon = Image.asset("images/BenchTEMP.png");
        break;
      case Workout.Squat:
        this._title = "Squat";
        this._icon = Image.asset("images/BarbellTEMP.png");
        break;
      case Workout.OverHeadPress:
        this._title = "Over-Head Press";
        this._icon = Image.asset("images/DumbbellTEMP.png");
        break;
      case Workout.BentOverRow:
        this._title = "Bent-Over Row";
        this._icon = Image.asset("images/WeightsTEMP.png");
        break;
      case Workout.Deadlift:
        this._title = "Deadlift";
        this._icon = Image.asset("images/DeadliftTEMP.png");
        break;
    }

    // Dynamically set widget theme
    switch (this.exercise.theme) {
      case ColorTheme.Yellow:
        _theme.add(Colors.yellow[400]);
        _theme.add(Colors.yellow[700]);
        break;
      case ColorTheme.Blue:
        _theme.add(Colors.lightBlue[200]);
        _theme.add(Colors.lightBlue[500]);
        break;
      case ColorTheme.Purple:
        _theme.add(Colors.purpleAccent[100]);
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
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  TextEditingController _repController;
  TextEditingController _weightController;

  @override
  void initState() {
    _repController = new TextEditingController();
    _weightController = new TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildCard(),
        _buildHeader(),
        _buildButtons(),
        Positioned(
            top: 60,
            left: 6,
            child: Container(
              width: 80,
              child: Column(
                children: <Widget>[
                  Text(
                    "Sets:",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.exercise.setList.length.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        _buildSetLog(),
      ],
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
      child: Container(
        height: 125,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget._theme[0].withOpacity(0.9),
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
                  widget._theme[0],
                  widget._theme[1],
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(70),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: <Widget>[
              Container(height: 65, child: Container(width: 75, child: widget._icon)),
              Container(
                width: 5,
              ),
              Text(
                widget._title,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  Widget _buildButtons() {
    Widget _minusBtn() {
      Dialog removeDialogue = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 16,
        child: Container(
          height: 200.0,
          child: Form(
            child: Column(children: <Widget>[
              Container(
                width: double.infinity,
                height: 20,
              ),
              Container(
                child: Text("Delte dis?"),
              ),
              Row(children: <Widget>[
                Container(
                  width: 20,
                ),
                Expanded(
                  child: RaisedButton(
                      color: Colors.lightBlueAccent[200],
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
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          if (widget.exercise.setList.length == 0)
                            widget.deleteExercise(widget.exercise.index);
                          else
                            widget.exercise.removeSet(widget.exercise.getSetCount()-1);

                          widget.updateSets();
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Remove",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                Container(
                  width: 20,
                ),
              ]),
            ]),
          ),
        ),
      );

      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 40,
        height: 40,
        child: IconButton(
          icon: Icon(Icons.remove),
          color: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return removeDialogue;
              },
            );
          },
        ),
      );
    }

    Widget _plusBtn() {
      Dialog addDialog = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 16,
        child: Container(
          height: 200.0,
          child: Form(
            child: Column(children: <Widget>[
              Container(
                width: double.infinity,
                height: 20,
              ),
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                    ),
                    Expanded(
                      child: TextField(
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.lightBlue, fontSize: 17),
                          controller: _repController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Repititions",
                              hintStyle: TextStyle(color: Colors.lightBlue),
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.lightBlue, width: 1),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)))),
                    ),
                    Container(
                      width: 50,
                    )
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                    ),
                    Expanded(
                      child: TextField(
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.lightBlue, fontSize: 17),
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Weight",
                              hintStyle: TextStyle(color: Colors.lightBlue),
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.lightBlue, width: 1),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)))),
                    ),
                    Container(
                      width: 50,
                    )
                  ],
                ),
              ),
              Container(
                height: 5,
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
                        setState(() {
                          // @ TODO Error handling
                          int reps = int.parse(_repController.text);
                          int weight = int.parse(_weightController.text);

                          widget.exercise.addSet(reps, weight);
                          widget.updateSets();
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
        ),
      );

      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 40,
        height: 40,
        child: IconButton(
          icon: Icon(Icons.add),
          color: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return addDialog;
              },
            );
          },
        ),
      );
    }

    return Positioned(
      top: 12,
      right: 55,
      child: Row(
        children: <Widget>[
          _minusBtn(),
          Container(
            width: 10,
          ),
          _plusBtn(),
        ],
      ),
    );
  }

  Widget _buildSetLog() {
    Widget Set(int rep, int weight) {
      return Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Container(
          width: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: Center(
                child: Text(
                  "$rep",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: Container(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              Expanded(
                  child: Center(
                    child: Text(
                      "$weight",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      );
    }

    List setLog = new List();
    for (int i = 0; i < widget.exercise.setList.length; i++) {
      int reps = widget.exercise.getReps(i);
      int weight = widget.exercise.getWeight(i);
      setLog.add(Set(reps, weight));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 55, left: 80, right: 22),
      child: Container(
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ...setLog.map((entry) {
              return entry;
            }).toList(),
          ],
        ),
      ),
    );
  }
}
