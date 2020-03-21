import 'package:fit_k/Enums/cardTheme.dart';
import 'package:flutter/cupertino.dart';

import '../Enums/workout.dart';

class Exercise {
  static int excerciseCount = 0;
  int index;
  final Workout workout;
  final setList = Map<int, List>();
  int setCount;
  ColorTheme color;
  Icon icon;

  Exercise({this.workout, this.color, this.icon}) {
    this.index = excerciseCount;
    excerciseCount++;

    this.setCount = 0;
  }

  void addSet(int reps, int weight) {
    this.setList.putIfAbsent(setCount, () => [reps, weight]);
    setCount++;
  }

  void removeSet(int key) {
    setList.remove(key);
  }

  static void updateExerciseCount() {
    excerciseCount--;
  }
}