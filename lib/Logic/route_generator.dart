import 'package:fit_k/Pages/page_exercise_creation.dart';
import 'package:fit_k/Pages/page_home.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/creationPage':
        if (args is Function) {
          return MaterialPageRoute(
            builder: (_) => ExerciseCreator(
              addExercise: args,
            ),
          );
        }

        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
