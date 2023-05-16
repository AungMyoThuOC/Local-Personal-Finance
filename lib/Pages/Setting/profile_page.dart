// ignore_for_file: sized_box_for_whitespace, must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Login/create_acc_page.dart';
import 'package:personal_finance/Pages/Setting/language.dart';
import 'package:personal_finance/Pages/Setting/logout_dialog.dart';
import 'package:personal_finance/Pages/Setting/security.dart';
import 'package:personal_finance/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  int id;
  ProfilePage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _db = CreateDatabase.instance;
  List getAccountList = [];
  bool tappedYes = false;

  _getAcc() async {
    List data = await _db.getAcc();
    getAccountList = data;
    setState(() {});
  }

  saveIdInSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('profile_id', widget.id);
  }

  @override
  void initState() {
    _getAcc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const Gap(15),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: CreateAccountPage(
                      checkPage: 1,
                      id: widget.id,
                    ),
                  ),
                );
                setState(() {});
              },
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300,
                            child: widget.id == 0
                                ? Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: CreateAccountPage(
                                                checkPage: 0,
                                                id: widget.id,
                                              ),
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: const AssetImage(
                                            "assets/images/person.png",
                                          ),
                                          backgroundColor: Colors.grey[350],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Hello ,",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: ubuntuFamily,
                                          fontSize: 25,
                                        ),
                                      )
                                    ],
                                  )
                                : getAccountList.isEmpty
                                    ? Container()
                                    : Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: CreateAccountPage(
                                                    checkPage: 1,
                                                    id: widget.id,
                                                  ),
                                                ),
                                              );
                                              setState(() {});
                                            },
                                            child: getAccountList[0]["image"] ==
                                                    ""
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        const AssetImage(
                                                      "assets/images/person.png",
                                                    ),
                                                    backgroundColor:
                                                        Colors.grey[350],
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage: FileImage(
                                                      File(
                                                        getAccountList[0]
                                                            ["image"],
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Hello, ${getAccountList[0]["name"]}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontFamily: ubuntuFamily,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                "${getAccountList[0]["phonenum"]}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontFamily: ubuntuFamily,
                                                  fontSize: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
                      setState(() {});
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
                          size: 21,
                          color: Colors.black,
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
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: Column(
            //     children: [
            //       TextButton(
            //         onPressed: () {
            //           Navigator.pushReplacement(
            //             context,
            //             PageTransition(
            //               child: const Security(),
            //               type: PageTransitionType.rightToLeft,
            //             ),
            //           );
            //         },
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             const Icon(
            //               Icons.security_outlined,
            //               size: 21,
            //               color: Colors.black,
            //             ),
            //             const SizedBox(
            //               width: 20,
            //             ),
            //             Text(
            //               "Security",
            //               style: TextStyle(
            //                 fontSize: 21,
            //                 fontFamily: ubuntuFamily,
            //                 color: Colors.black,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      final action = await AlertDialogs.yesCalcelDialog(
                        context,
                        "Logout",
                        "Are you sure ?",
                      );
                      if (action == DialogsAction.yes) {
                        setState(
                          () => tappedYes = true,
                        );
                      } else {
                        setState(
                          () => tappedYes = false,
                        );
                      }
                    },
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
              child: const Text(
                "Confirm",
                style: TextStyle(
                  color: Color(0xFFFF1818),
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  // _db.deleteRecordOut(getOutDataList[index]["AutoID"]);
                  _db.deleteRecord(widget.id);
                  _db.deleteRecordOut(widget.id);
                  _db.deleteRecordRem(widget.id);
                  _db.deleteRecordSav(widget.id);
                });
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xFF5463FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
