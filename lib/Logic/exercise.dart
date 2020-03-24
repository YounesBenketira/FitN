import 'package:fit_k/Enums/cardTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Enums/workout.dart';

class Exercise {
  static int excerciseCount = 0;
  int id;
  var setList = Map<String, dynamic>();
  Workout workout;
  ColorTheme theme;
  Icon icon;

  Exercise({this.id, this.workout, this.theme, this.icon}) {
    excerciseCount++;
  }

  Exercise.fromJson(Map<String, dynamic> map){
    id = map['id'];
    workout = Workout.values[map['workout']];
    theme = ColorTheme.values[map['theme']];
    setList = map['setList'];
  }

  Map<String, dynamic> toJson(){
    var map = <String, dynamic>{
      'id': id,
      'workout': workout.index,
      'theme': theme.index,
      'setList': setList
    };
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
    return "$id $workout $theme $setList";
  }
}
