import 'package:fit_k/Enums/cardTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Enums/workout.dart';

class Exercise {
  static int excerciseCount = 0;
  int id;
  var setList = Map<dynamic, dynamic>();
  Workout workout;
  ColorTheme theme;
  Image icon;
  String title;

  Exercise({this.id, this.workout, this.theme}) {
    switch (this.workout) {
      case Workout.ArnoldDumbbellPress:
        this.title = 'Arnold DB Press';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.OverheadPress:
        this.title = 'Overhead Press';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.SeatedDumbbellPress:
        this.title = 'Seated DB Press';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.LogPress:
        this.title = 'Log Press';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.OneArmStandingDumbbellPress:
        this.title = 'Standing DB Press';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.PushPress:
        this.title = 'Push Press';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.FrontDumbbellRaise:
        this.title = 'Front DB Raise';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.LateralRaise:
        this.title = 'Lateral Raise';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.RearDeltDumbbellRaise:
        this.title = 'R. Delt DB Raise';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.FacePull:
        this.title = 'Face Pull';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.RearDeltFly:
        this.title = 'R. Delt Fly';
        this.icon = Image.asset('images/Exercises/shoulders.png');
        break;
      case Workout.TricepsExtension:
        this.title = 'Triceps Extension';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.CloseGripBenchPress:
        this.title = 'Close Grip Bench';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.OverheadTricepsExtension:
        this.title = 'OH Triceps Ext.';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.Skullcrusher:
        this.title = 'Skull Crusher';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.TricepsDip:
        this.title = 'Triceps Dip';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.RopePushDown:
        this.title = 'Rope Push Down';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.VBarPushDown:
        this.title = 'V-Bar Push Down';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.BarbellCurl:
        this.title = 'Barbell Curl';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.CableCurl:
        this.title = 'Cable Curl';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.DumbbellCurl:
        this.title = 'Dumbbell Curl';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.ConcentrationCurl:
        this.title = 'Concentration Curl';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.HammerCurl:
        this.title = 'Hammer Curl';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.PreacherCurl:
        this.title = 'Preacher Curl';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.InclineDumbbellCurl:
        this.title = 'Incline DB Curl';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.MachineCurl:
        this.title = 'Machine Curl';
        this.icon = Image.asset('images/Exercises/arms.png');
        break;
      case Workout.CableCrossover:
        this.title = 'Cable Crossover';
        this.icon = Image.asset('images/Exercises/chest.png');
        break;
      case Workout.DeclineBenchPress:
        this.title = 'Decline Bench';
        this.icon = Image.asset('images/Exercises/chest.png');
        break;
      case Workout.BenchPress:
        this.title = 'Bench';
        this.icon = Image.asset('images/Exercises/chest.png');
        break;
      case Workout.DumbbellFly:
        this.title = 'Dumbbell Fly';
        this.icon = Image.asset('images/Exercises/chest.png');
        break;
      case Workout.InclineBenchPress:
        this.title = 'Incline Bench';
        this.icon = Image.asset('images/Exercises/chest.png');
        break;
      case Workout.InclineDumbbellFly:
        this.title = 'Incline Fly';
        this.icon = Image.asset('images/Exercises/chest.png');
        break;
      case Workout.MachineFly:
        this.title = 'Machine Fly';
        this.icon = Image.asset('images/Exercises/chest.png');
        break;
      case Workout.BarbellRow:
        this.title = 'Barbell Row';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.BarbellShrug:
        this.title = 'Barbell Shrug';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.DumbbellShrug:
        this.title = 'Dumbbell Shrug';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.ChinUp:
        this.title = 'Chin Up';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.Deadlift:
        this.title = 'Deadlift';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.DumbbellRow:
        this.title = 'Dumbbell Row';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.GoodMorning:
        this.title = 'Good Morning';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.HammerStrengthRow:
        this.title = 'Hammer Strength Row';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.LatPulldown:
        this.title = 'Lat Pulldown';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.PendlayRow:
        this.title = 'Pendlay Row';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.PullUp:
        this.title = 'Pull Up';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.RackPull:
        this.title = 'Rack Pull';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.SeatedCableRow:
        this.title = 'Seated Cable Row';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.CablePushdown:
        this.title = 'Cable Pushdown';
        this.icon = Image.asset('images/Exercises/back.png');
        break;
      case Workout.BarbellFrontSquat:
        this.title = 'Front Squat';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.BarbellGluteBridge:
        this.title = 'Glute Bridge';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.BarbellSquat:
        this.title = 'Squat';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.DonkeyCalfRaise:
        this.title = 'Donkey Calf Raise';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.GluteHamRaise:
        this.title = 'Glute Ham Raise';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.LegExtension:
        this.title = 'Leg Extension';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.LegPress:
        this.title = 'Leg Press';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.LegCurl:
        this.title = 'Leg Curl';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.RomanianDeadlift:
        this.title = 'Romanian Deadlift';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.SeatedCalfRaise:
        this.title = 'Seated Calf Raise';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.StandingCalfRaise:
        this.title = 'Standing Calf Raise';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.StiffLeggedDeadlift:
        this.title = 'SL. Deadlift';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.SumoDeadlift:
        this.title = 'Sumo Deadlift';
        this.icon = Image.asset('images/Exercises/legs.png');
        break;
      case Workout.AbWheelRollout:
        this.title = 'Ab Wheel Rollout';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.CableCrunch:
        this.title = 'Cable Crunch';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.Crunch:
        this.title = 'Crunch';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.DeclineCrunch:
        this.title = 'Decline Crunch';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.DragonFlag:
        this.title = 'Dragon Flag';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.HangingKneeRaise:
        this.title = 'Knee Raise';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.HangingLegRaise:
        this.title = 'Leg Raise';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.Plank:
        this.title = 'Plank';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.SidePlank:
        this.title = 'Side Plank';
        this.icon = Image.asset('images/Exercises/abs.png');
        break;
      case Workout.Cycling:
        this.title = 'Cycling';
        this.icon = Image.asset('images/Exercises/cardio.png');
        break;
      case Workout.Elliptical:
        this.title = 'Elliptical';
        this.icon = Image.asset('images/Exercises/cardio.png');
        break;
      case Workout.RowingMachine:
        this.title = 'Rowing Machine';
        this.icon = Image.asset('images/Exercises/cardio.png');
        break;
      case Workout.Running:
        this.title = 'Running';
        this.icon = Image.asset('images/Exercises/cardio.png');
        break;
      case Workout.Bike:
        this.title = 'Bike';
        this.icon = Image.asset('images/Exercises/cardio.png');
        break;
      case Workout.Swimming:
        this.title = 'Swimming';
        this.icon = Image.asset('images/Exercises/cardio.png');
        break;
      case Workout.Walking:
        this.title = 'Walking';
        this.icon = Image.asset('images/Exercises/cardio.png');
        break;
    }
    this.setList = {};
    excerciseCount++;
  }

  Exercise.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    workout = Workout.values[map['workout']];
    theme = ColorTheme.values[map['theme']];
    setList = map['setList'];
    title = map['title'];
    icon = Image.asset(map['icon']);
  }

  Map<String, dynamic> toJson(){
    var map = <String, dynamic>{
      'id': id,
      'workout': workout.index,
      'theme': theme.index,
      'setList': setList,
      'title': title,
      'icon':
          icon.image.toString().substring(32, icon.image.toString().length - 2)
    };

//    print();
    return map;
  }

  void addSet(int reps, int weight) {
    this.setList.putIfAbsent(setList.length.toString(), () => [reps, weight]);
  }

  void removeSet(int key) {
    setList.remove(key);
  }

  static void updateExerciseCount() {
    excerciseCount--;
  }

  int getSetCount() {
    return this.setList.length;
  }

  int getReps(int set) {
    return setList[set.toString()][0];
  }

  int getWeight(int set) {
    return setList[set.toString()][1];
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
