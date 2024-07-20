import 'package:dictionary/db.dart';
import 'words.dart';
import 'package:dictionary/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MyData());
  DBUtil Db = new DBUtil();
  Get.find<MyData>().list = await Db.select("SELECT * FROM items LIMIT 100");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'Screen',
      routes: {
        '/': (context) => Screen(),
        '/Words': (context) => Words(),
      },
    );
  }
}
