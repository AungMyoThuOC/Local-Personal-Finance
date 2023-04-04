// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _db = CreateDatabase.instance;

void main() {
  SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  // _db.deleteDB();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
