// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Login/login_page.dart';
import 'package:personal_finance/Pages/Login/register_or_login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartState();
  }
}

class StartState extends State<SplashScreen> {
  final _db = CreateDatabase.instance;

  startTimer() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, route);
  }

  route() async {
    List data = await _db.getAcc();
    List accountList = [];
    accountList = data;
    if (accountList.isEmpty) {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterOrLoginPage(),
        ),
      );
    } else {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginAccountPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Image.asset(
        //   "images/gem.png",
        //   width: 200,
        //   height: 200,
        // ),
      ),
    );
  }
}
