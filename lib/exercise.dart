import './workout.dart';

class Exercise {
  final Workout workout;
  final setList = Map<int, List>();
  int setCount;

  Exercise({this.workout}) {
    this.setCount = 0;
  }

  void addSet(int reps, int weight) {
    this.setList.putIfAbsent(setCount, () => [reps, weight]);
    setCount++;
  }

  void removeSet(int key){
    setList.remove(key);
  }

}