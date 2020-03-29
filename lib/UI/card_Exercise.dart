import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Logic/data_storage.dart';
import 'package:fit_k/UI/ui_set.dart';
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
  Function updateDataSet;

  ExerciseCard({this.exercise, this.deleteExercise, this.updateDataSet}) {
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
        this._title = "OH Press";
        this._icon = Image.asset("images/DumbbellTEMP.png");
        break;
      case Workout.BentOverRow:
        this._title = "Row";
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
        _theme.add(Colors.yellow[300]);
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
        _theme.add(Colors.deepOrange[500]);
        break;
      case ColorTheme.Green:
        _theme.add(Colors.greenAccent[200]);
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
  Storage _storage;

  @override
  void initState() {
    _repController = new TextEditingController();
    _weightController = new TextEditingController();

    _storage = Storage();

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
            top: 65,
            left: 22.5,
            child: Text(
              'x${widget.exercise.setList.length.toString()}',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
        height: 106,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget._theme[0].withOpacity(0.9),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 3, // has the effect of extending the shadow
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
                  widget._theme[0],
                  widget._theme[1],
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(50),
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
      padding: const EdgeInsets.only(left: 10, top: 0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: <Widget>[
              Container(height: 62.5, child: widget._icon),
              Container(
                width: 5,
              ),
              Container(
                width: 150,
                height: 35,
                child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.contain,
                    child: Text(
                      widget._title,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          )),
    );
  }

  Widget _buildButtons() {
    Widget _minusBtn() {
      Text displayText;
      if (widget.exercise.setList.length == 0)
        displayText = Text(
          'Remove this exercise?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      else
        displayText = Text(
          'Remove the last set?',
          style: TextStyle(fontSize: 23),
        );

      Dialog removeDialogue = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 16,
        child: Container(
          height: 155.0,
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 25.0),
              child: displayText,
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
                  ),
                ),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                child: RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        int id = widget.exercise.id;
                        if (widget.exercise.setList.length == 0)
                          widget.deleteExercise(id);
                        else {
                          widget.exercise
                              .removeSet(widget.exercise.getSetCount() - 1);
                          _storage.removeSet(
                              widget.exercise, widget.updateDataSet);
                        }
                      });
//                        widget.updateSets();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Remove",
                      style: TextStyle(fontSize: 19, color: Colors.white),
                    )),
              ),
              Container(
                width: 20,
              ),
            ]),
//            Container(
//              height: 30,
//            ),
          ]),
        ),
      );

      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 35,
        height: 35,
        child: IconButton(
          iconSize: 20,
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
          height: 220.0,
          child: Form(
            child: Column(children: <Widget>[
              Container(
                width: double.infinity,
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 12,
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
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            fontSize: 20,
                          ),
                          controller: _repController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "# of Repititions",
                              hintStyle: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  fontSize: 20),
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  width: 1,
                                ),
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
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            fontSize: 20,
                          ),
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Weight (lbs./kg)",
                              hintStyle: TextStyle(
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                fontSize: 20,
                              ),
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.only(bottom: 1),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  width: 1,
                                ),
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
//                          print("BEFORE: " + widget.exercise.toString());
                          widget.exercise.setList.putIfAbsent(
                              widget.exercise.setList.length.toString(),
                              () => [reps, weight]);

//                          print("AFTER: " + widget.exercise.toString());
                        });
                        _storage.saveSet(widget.exercise, widget.updateDataSet);
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
        width: 35,
        height: 35,
        child: IconButton(
          iconSize: 20,
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
      right: 35,
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
    List<Widget> setList = new List();
    for (int i = 0; i < widget.exercise.setList.length; i++) {
      SetUI set = SetUI(
          rep: widget.exercise.setList[i.toString()][0],
          weight: widget.exercise.setList[i.toString()][1]);
      setList.add(set);
    }
    ;

    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 75, right: 22),
      child: Container(
        height: 59,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
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
}
