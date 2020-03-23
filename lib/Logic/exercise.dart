import 'package:fit_k/Enums/cardTheme.dart';
import 'package:flutter/cupertino.dart';

import '../Enums/workout.dart';

class Exercise {
  static int excerciseCount = 0;
  int id;
  var setList = Map<int, List>();
  Workout workout;
  ColorTheme theme;
  Icon icon;

  Exercise({this.id, this.workout, this.theme, this.icon}) {
    excerciseCount++;
  }

  void addSet(int reps, int weight) {
    this.setList.putIfAbsent(setList.length, () => [reps, weight]);
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
    return setList[set][0];
  }

  int getWeight(int set) {
    return setList[set][1];
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$id $workout $theme";
  }
}
