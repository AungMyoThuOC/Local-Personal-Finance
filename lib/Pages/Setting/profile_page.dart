// ignore_for_file: sized_box_for_whitespace, must_be_immutable

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Pages/Setting/language.dart';
import 'package:personal_finance/common.dart';

class ProfilePage extends StatefulWidget {
  int id;
  List list;
  ProfilePage({
    Key? key,
    required this.id,
    required this.list,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
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
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // Column(
            //   children: [
            //     getAccountList.isEmpty
            //         ? Container()
            //         : Row(
            //             children: [
            //               getAccountList[0]["image"] == ""
            //                   ? CircleAvatar(
            //                       backgroundImage: const AssetImage(
            //                         "images/prson.jpg",
            //                       ),
            //                       backgroundColor: Colors.grey[350],
            //                     )
            //                   : CircleAvatar(
            //                       backgroundImage: FileImage(
            //                         File(
            //                           getAccountList[0]["image"],
            //                         ),
            //                       ),
            //                     ),
            //               const SizedBox(
            //                 width: 10,
            //               ),
            //               Text(
            //                 "${getAccountList[0]['name']}",
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black,
            //                   fontFamily: ubuntuFamily,
            //                   fontSize: 20,
            //                 ),
            //               )
            //             ],
            //           )
            //   ],
            // ),
            // Column(
            //   children: const [
            //     // Image.asset(
            //     //   "assets/images/budget.png",
            //     //   height: 100,
            //     //   fit: BoxFit.contain,
            //     // ),
            //     SizedBox(
            //       height: 13,
            //     ),
            //     Text(
            //       "Personal Finance",
            //       style: TextStyle(
            //         fontSize: 25,
            //         color: Color(0xff5E65DE),
            //       ),
            //     ),
            //     Text(
            //       "v 0.1.2",
            //       style: TextStyle(
            //         fontSize: 13,
            //         fontWeight: FontWeight.bold,

            //         //
            //       ),
            //     ),
            //     SizedBox(height: 13),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const LanguagePage(),
                        ),
                      );
                      setState(() {
                        
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.g_translate_outlined,
                          size: 21,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Language",
                          style: TextStyle(
                            fontSize: 21,
                            fontFamily: ubuntuFamily,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
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
                          width: 20,
                        ),
                        Text(
                          "Reset Data",
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
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.logout_outlined,
                          size: 21,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 21,
                            fontFamily: ubuntuFamily,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 21,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "About",
                          style: TextStyle(
                            fontSize: 21,
                            fontFamily: ubuntuFamily,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )
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
