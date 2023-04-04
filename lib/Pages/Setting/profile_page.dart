// ignore_for_file: sized_box_for_whitespace, must_be_immutable

import 'package:flutter/material.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/common.dart';

class ProfilePage extends StatefulWidget {
  List list;
  ProfilePage({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _db = CreateDatabase.instance;
  List getIndexDashboardList = [];
  bool check = false;

  _getData() {
    getIndexDashboardList = widget.list;
  }

  @override
  void initState() {
    _getData();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        check = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Setting",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 56,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.01),
                    spreadRadius: 10,
                    blurRadius: 3,
                  ),
                ],
                // gradient: LinearGradient(
                //   colors: Colors.white,
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   stops: const [0.0, 2.0],
                //   tileMode: TileMode.clamp,
                // ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: const [
                // Image.asset(
                //   "assets/images/budget.png",
                //   height: 100,
                //   fit: BoxFit.contain,
                // ),
                SizedBox(
                  height: 13,
                ),
                Text(
                  "Personal Finance",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xff5E65DE),
                  ),
                ),
                Text(
                  "v 0.1.2",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,

                    //
                  ),
                ),
                SizedBox(height: 13),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  InkWell(
                    onTap: showResetDialog,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.restore_outlined,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Rsset Data",
                          style: TextStyle(
                            fontSize: 21,
                            fontFamily: ubuntuFamily,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showResetDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Clear Expense Entries"),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text("Do you want to clear all expeense entries?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }
}
