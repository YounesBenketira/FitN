import 'package:fit_k/Enums/cardTheme.dart';
import 'package:flutter/cupertino.dart';

import '../Enums/workout.dart';

class Exercise {
  static int excerciseCount = 0;
  int index;
  final setList = Map<int, List>();
  final Workout workout;
  final ColorTheme theme;
  final Icon icon;

  Exercise({this.workout, this.theme, this.icon}) {
    this.index = excerciseCount;
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

  int getSetCount(){
    return this.setList.length;
  }

  int getReps(int set){
    return setList[set][0];
  }

  int getWeight(int set){
    return setList[set][1];
  }
}