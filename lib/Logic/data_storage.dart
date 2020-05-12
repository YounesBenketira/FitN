import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fit_k/Logic/exercise.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  static DateTime now = new DateTime.now();

  static DateTime todaysDate = new DateTime(now.year, now.month, now.day);
//  static DateTime todaysDate = new DateTime(2020, 5, 14);

  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/exercises.txt');
  }

  Future<List<dynamic>> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();

      List<dynamic> data = jsonDecode(body);

      return data;
    } catch (e) {
      return List<dynamic>();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;

    return await file.writeAsString("$data");
  }

  void save(var data) async {
    String jsonData = jsonEncode(data);
    await writeData(jsonData);
  }

  void saveSet(Exercise exercise, Function updateDataSet) async {
    return await readData().then((var data) async {
      List<dynamic> dataHolder = data;
//      print(data);
      for (int i = 0; i < dataHolder.length; i++)
        if (dataHolder[i]['date'] == todaysDate.toIso8601String()) {
          Map<String, dynamic> setList =
              dataHolder[i]['exercises'][exercise.id]['setList'];

          String setListKey = (exercise.setList.length - 1).toString();
          setList.putIfAbsent(
              setList.length.toString(),
              () => [
                    exercise.setList[setListKey][0],
                    exercise.setList[setListKey][1]
                  ]);

          await writeData(jsonEncode(data));
        }
      updateDataSet();
    });
  }

  void removeSet(Exercise exercise, Function updateDataSet) {
    readData().then((var data) {
      for (int i = 0; i < data.length; i++)
        if (data[i]['date'] == todaysDate.toIso8601String()) {
          String setListKey = (exercise.setList.length - 1).toString();
          data[i]['exercises'][exercise.id]['setList'].remove(setListKey);
        }
      writeData(jsonEncode(data));
      updateDataSet();
    });
  }
}
