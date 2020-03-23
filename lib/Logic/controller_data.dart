import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataController{

  DataController._privateConstructor();
  static final DataController instance = DataController._privateConstructor();

  Future<String> get _localPath async{
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent(List<Map> dataList) async {
    final file = await _localFile;

    print(dataList.toString());
//    print(dataList);

    return file.writeAsString(dataList.toString());
  }

  Future<String> readcontent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
//      print(contents);
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }

}