import 'dart:math';

import './workout.dart';

class Exercise {
  final Workout workout;
  Map<int, List> setList = { 0:[]};
  int setCount;

  Exercise({this.workout}){
    this.setCount = 0;
  }

  void addSet(int reps, int weight){
//    print(this.setCount);
//    print(this.setList.length);
    this.setList.putIfAbsent(setCount, () => [reps, weight]);
    setCount++;
  }

  void removeSet(int key){
    setList.remove(key);
  }

}