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
      case Workout.ArnoldDumbbellPress:
        this._title = 'Arnold DB Press';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.OverheadPress:
        this._title = 'Overhead Press';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.SeatedDumbbellPress:
        this._title = 'Seated DB Press';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.LogPress:
        this._title = 'Log Press';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.OneArmStandingDumbbellPress:
        this._title = 'Standing DB Press';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.PushPress:
        this._title = 'Push Press';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.FrontDumbbellRaise:
        this._title = 'Front DB Raise';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.LateralRaise:
        this._title = 'Lateral Raise';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.RearDeltDumbbellRaise:
        this._title = 'R. Delt DB Raise';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.FacePull:
        this._title = 'Face Pull';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.RearDeltFly:
        this._title = 'R. Delt Fly';
        this._icon = Image.asset('images/shoulders.png');
        break;
      case Workout.TricepsExtension:
        this._title = 'Triceps Extension';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.CloseGripBenchPress:
        this._title = 'Close Grip Bench';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.OverheadTricepsExtension:
        this._title = 'OH Triceps Ext.';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.Skullcrusher:
        this._title = 'Skull Crusher';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.TricepsDip:
        this._title = 'Triceps Dip';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.RopePushDown:
        this._title = 'Rope Push Down';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.VBarPushDown:
        this._title = 'V-Bar Push Down';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.BarbellCurl:
        this._title = 'Barbell Curl';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.CableCurl:
        this._title = 'Cable Curl';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.DumbbellCurl:
        this._title = 'Dumbbell Curl';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.ConcentrationCurl:
        this._title = 'Concentration Curl';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.HammerCurl:
        this._title = 'Hammer Curl';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.PreacherCurl:
        this._title = 'Preacher Curl';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.InclineDumbbellCurl:
        this._title = 'Incline DB Curl';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.MachineCurl:
        this._title = 'Machine Curl';
        this._icon = Image.asset('images/arms.png');
        break;
      case Workout.CableCrossover:
        this._title = 'Cable Crossover';
        this._icon = Image.asset('images/chest.png');
        break;
      case Workout.DeclineBenchPress:
        this._title = 'Decline Bench';
        this._icon = Image.asset('images/chest.png');
        break;
      case Workout.BenchPress:
        this._title = 'Bench';
        this._icon = Image.asset('images/chest.png');
        break;
      case Workout.DumbbellFly:
        this._title = 'Dumbbell Fly';
        this._icon = Image.asset('images/chest.png');
        break;
      case Workout.InclineBenchPress:
        this._title = 'Incline Bench';
        this._icon = Image.asset('images/chest.png');
        break;
      case Workout.InclineDumbbellFly:
        this._title = 'Incline Fly';
        this._icon = Image.asset('images/chest.png');
        break;
      case Workout.MachineFly:
        this._title = 'Machine Fly';
        this._icon = Image.asset('images/chest.png');
        break;
      case Workout.BarbellRow:
        this._title = 'Barbell Row';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.BarbellShrug:
        this._title = 'Barbell Shrug';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.DumbbellShrug:
        this._title = 'Dumbbell Shrug';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.ChinUp:
        this._title = 'Chin Up';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.Deadlift:
        this._title = 'Deadlift';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.DumbbellRow:
        this._title = 'Dumbbell Row';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.GoodMorning:
        this._title = 'Good Morning';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.HammerStrengthRow:
        this._title = 'Hammer Strength Row';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.LatPulldown:
        this._title = 'Lat Pulldown';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.PendlayRow:
        this._title = 'Pendlay Row';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.PullUp:
        this._title = 'Pull Up';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.RackPull:
        this._title = 'Rack Pull';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.SeatedCableRow:
        this._title = 'Seated Cable Row';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.CablePushdown:
        this._title = 'Cable Pushdown';
        this._icon = Image.asset('images/back.png');
        break;
      case Workout.BarbellFrontSquat:
        this._title = 'Front Squat';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.BarbellGluteBridge:
        this._title = 'Glute Bridge';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.BarbellSquat:
        this._title = 'Squat';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.DonkeyCalfRaise:
        this._title = 'Donkey Calf Raise';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.GluteHamRaise:
        this._title = 'Glute Ham Raise';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.LegExtension:
        this._title = 'Leg Extension';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.LegPress:
        this._title = 'Leg Press';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.LegCurl:
        this._title = 'Leg Curl';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.RomanianDeadlift:
        this._title = 'Romanian Deadlift';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.SeatedCalfRaise:
        this._title = 'Seated Calf Raise';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.StandingCalfRaise:
        this._title = 'Standing Calf Raise';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.StiffLeggedDeadlift:
        this._title = 'SL. Deadlift';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.SumoDeadlift:
        this._title = 'Sumo Deadlift';
        this._icon = Image.asset('images/legs.png');
        break;
      case Workout.AbWheelRollout:
        this._title = 'Ab Wheel Rollout';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.CableCrunch:
        this._title = 'Cable Crunch';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.Crunch:
        this._title = 'Crunch';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.DeclineCrunch:
        this._title = 'Decline Crunch';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.DragonFlag:
        this._title = 'Dragon Flag';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.HangingKneeRaise:
        this._title = 'Knee Raise';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.HangingLegRaise:
        this._title = 'Leg Raise';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.Plank:
        this._title = 'Plank';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.SidePlank:
        this._title = 'Side Plank';
        this._icon = Image.asset('images/abs.png');
        break;
      case Workout.Cycling:
        this._title = 'Cycling';
        this._icon = Image.asset('images/cardio.png');
        break;
      case Workout.Elliptical:
        this._title = 'Elliptical';
        this._icon = Image.asset('images/cardio.png');
        break;
      case Workout.RowingMachine:
        this._title = 'Rowing Machine';
        this._icon = Image.asset('images/cardio.png');
        break;
      case Workout.Running:
        this._title = 'Running';
        this._icon = Image.asset('images/cardio.png');
        break;
      case Workout.Bike:
        this._title = 'Bike';
        this._icon = Image.asset('images/cardio.png');
        break;
      case Workout.Swimming:
        this._title = 'Swimming';
        this._icon = Image.asset('images/cardio.png');
        break;
      case Workout.Walking:
        this._title = 'Walking';
        this._icon = Image.asset('images/cardio.png');
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
        Positioned(
          left: 6,
          child: Container(height: 70, child: widget._icon),
        ),
        Positioned(
          left: 78,
          top: 12.5,
          child: Container(
            width: 170,
            height: 30,
            child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.contain,
                child: Text(
                  widget._title,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans"),
                )),
          ),
        ),
        _buildButtons(),
        Positioned(
            top: 70,
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
                topRight: Radius.circular(30),
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
            children: <Widget>[],
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
                            color: Theme.of(context).primaryColorDark,
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
      right: 25,
      child: Row(
        children: <Widget>[
          _minusBtn(),
          Container(
            width: 5,
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
