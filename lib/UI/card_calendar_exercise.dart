import 'package:fit_k/Enums/cardTheme.dart';
import 'package:fit_k/Enums/workout.dart';
import 'package:fit_k/Logic/exercise.dart';
import 'package:fit_k/UI/ui_set.dart';
import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final Exercise exercise;
  final bool showSets;

  String _title;
  List<Color> _theme = new List();

  CalendarCard({this.exercise, this.showSets}) {
    switch (this.exercise.workout) {
      case Workout.ArnoldDumbbellPress:
        this._title = 'Arnold DB Press';
        break;
      case Workout.OverheadPress:
        this._title = 'Overhead Press';
        break;
      case Workout.SeatedDumbbellPress:
        this._title = 'Seated DB Press';
        break;
      case Workout.LogPress:
        this._title = 'Log Press';
        break;
      case Workout.OneArmStandingDumbbellPress:
        this._title = 'Standing DB Press';
        break;
      case Workout.PushPress:
        this._title = 'Push Press';
        break;
      case Workout.FrontDumbbellRaise:
        this._title = 'Front DB Raise';
        break;
      case Workout.LateralRaise:
        this._title = 'Lateral Raise';
        break;
      case Workout.RearDeltDumbbellRaise:
        this._title = 'R. Delt DB Raise';
        break;
      case Workout.FacePull:
        this._title = 'Face Pull';
        break;
      case Workout.RearDeltFly:
        _title = 'R. Delt Fly';
        break;
      case Workout.TricepsExtension:
        this._title = 'Triceps Extension';
        break;
      case Workout.CloseGripBenchPress:
        this._title = 'Close Grip Bench';
        break;
      case Workout.OverheadTricepsExtension:
        this._title = 'OH. Triceps Extension';
        break;
      case Workout.Skullcrusher:
        this._title = 'Skull Crusher';
        break;
      case Workout.TricepsDip:
        this._title = 'Triceps Dip';
        break;
      case Workout.RopePushDown:
        this._title = 'Rope Push Down';
        break;
      case Workout.VBarPushDown:
        this._title = 'V-Bar Push Down';
        break;
      case Workout.BarbellCurl:
        this._title = 'Barbell Curl';
        break;
      case Workout.CableCurl:
        this._title = 'Cable Curl';
        break;
      case Workout.DumbbellCurl:
        this._title = 'Dumbbell Curl';
        break;
      case Workout.ConcentrationCurl:
        this._title = 'Concentration Curl';
        break;
      case Workout.HammerCurl:
        this._title = 'Hammer Curl';
        break;
      case Workout.PreacherCurl:
        this._title = 'Preacher Curl';
        break;
      case Workout.InclineDumbbellCurl:
        this._title = 'Incline DB Curl';
        break;
      case Workout.MachineCurl:
        this._title = 'Machine Curl';
        break;
      case Workout.CableCrossover:
        this._title = 'Cable Crossover';
        break;
      case Workout.DeclineBenchPress:
        this._title = 'Decline Bench';
        break;
      case Workout.BenchPress:
        this._title = 'Bench';
        break;
      case Workout.DumbbellFly:
        this._title = 'Dumbbell Fly';
        break;
      case Workout.InclineBenchPress:
        this._title = 'Incline Bench';
        break;
      case Workout.InclineDumbbellFly:
        this._title = 'Incline Fly';
        break;
      case Workout.MachineFly:
        this._title = 'Machine Fly';
        break;
      case Workout.BarbellRow:
        this._title = 'Barbell Row';
        break;
      case Workout.BarbellShrug:
        this._title = 'Barbell Shrug';
        break;
      case Workout.DumbbellShrug:
        this._title = 'Dumbbell Shrug';
        break;
      case Workout.ChinUp:
        this._title = 'Chin Up';
        break;
      case Workout.Deadlift:
        this._title = 'Deadlift';
        break;
      case Workout.DumbbellRow:
        this._title = 'Dumbbell Row';
        break;
      case Workout.GoodMorning:
        this._title = 'Good Morning';
        break;
      case Workout.HammerStrengthRow:
        this._title = 'Hammer Strength Row';
        break;
      case Workout.LatPulldown:
        this._title = 'Lat Pulldown';
        break;
      case Workout.PendlayRow:
        this._title = 'Pendlay Row';
        break;
      case Workout.PullUp:
        this._title = 'Pull Up';
        break;
      case Workout.RackPull:
        this._title = 'Rack Pull';
        break;
      case Workout.SeatedCableRow:
        this._title = 'Seated Cable Row';
        break;
      case Workout.CablePushdown:
        this._title = 'Cable Pushdown';
        break;
      case Workout.BarbellFrontSquat:
        this._title = 'Front Squat';
        break;
      case Workout.BarbellGluteBridge:
        this._title = 'Glute Bridge';
        break;
      case Workout.BarbellSquat:
        this._title = 'Squat';
        break;
      case Workout.DonkeyCalfRaise:
        this._title = 'Donkey Calf Raise';
        break;
      case Workout.GluteHamRaise:
        this._title = 'Glute Ham Raise';
        break;
      case Workout.LegExtension:
        this._title = 'Leg Extension';
        break;
      case Workout.LegPress:
        this._title = 'Leg Press';
        break;
      case Workout.LegCurl:
        this._title = 'Leg Curl';
        break;
      case Workout.RomanianDeadlift:
        this._title = 'Romanian Deadlift';
        break;
      case Workout.SeatedCalfRaise:
        this._title = 'Seated Calf Raise';
        break;
      case Workout.StandingCalfRaise:
        this._title = 'Standing Calf Raise';
        break;
      case Workout.StiffLeggedDeadlift:
        this._title = 'SL. Deadlift';
        break;
      case Workout.SumoDeadlift:
        this._title = 'Sumo Deadlift';
        break;
      case Workout.AbWheelRollout:
        this._title = 'Ab Wheel Rollout';
        break;
      case Workout.CableCrunch:
        this._title = 'Cable Crunch';
        break;
      case Workout.Crunch:
        this._title = 'Crunch';
        break;
      case Workout.DeclineCrunch:
        this._title = 'Decline Crunch';
        break;
      case Workout.DragonFlag:
        this._title = 'Dragon Flag';
        break;
      case Workout.HangingKneeRaise:
        this._title = 'Knee Raise';
        break;
      case Workout.HangingLegRaise:
        this._title = 'Leg Raise';
        break;
      case Workout.Plank:
        this._title = 'Plank';
        break;
      case Workout.SidePlank:
        this._title = 'Side Plank';
        break;
      case Workout.Cycling:
        this._title = 'Cycling';
        break;
      case Workout.Elliptical:
        this._title = 'Elliptical';
        break;
      case Workout.RowingMachine:
        this._title = 'Rowing Machine';
        break;
      case Workout.Running:
        this._title = 'Running';
        break;
      case Workout.Bike:
        this._title = 'Bike';
        break;
      case Workout.Swimming:
        this._title = 'Swimming';
        break;
      case Workout.Walking:
        this._title = 'Walking';
        break;
    }

    // Dynamically set widget theme
    switch (this.exercise.theme) {
      case ColorTheme.Red:
        _theme.add(Color(0xffe52d27));
        _theme.add(Color(0xffFF512F));
        break;
      case ColorTheme.Blue:
        _theme.add(Color(0xff17EAD9));
        _theme.add(Color(0xff6078EA));
        break;
      case ColorTheme.Pink:
        _theme.add(Color(0xffc471f5));
        _theme.add(Color(0xfffa71cd));
        break;
      case ColorTheme.Peach:
        _theme.add(Color(0xffFCE38A));
        _theme.add(Color(0xffF38181));
        break;
      case ColorTheme.Green:
        _theme.add(Color(0xff42E695));
        _theme.add(Color(0xff3BB2B8));
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
        right: 100,
        left: 22,
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

    Widget _buildSetCount() {
      return Positioned(
        top: 14,
        right: 50,
        child: Text(
          'x${setList.length}',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
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
//                  color: _theme[0].withOpacity(0.9),
                  color: Colors.grey.withOpacity(0.7),
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
          top: 22,
          child: Text(
            showSets ? '' : '$_title',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        showSets ? _buildSetList() : Container(),
        _buildSetCount(),
      ],
    );
  }
}
