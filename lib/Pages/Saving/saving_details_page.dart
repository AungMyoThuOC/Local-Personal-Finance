// ignore_for_file: must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Saving/saving_add_edit_page.dart';
import 'package:personal_finance/Pages/Saving/saving_list.dart';
import 'package:personal_finance/Pages/Saving/saving_page.dart';
import 'package:personal_finance/common.dart';

class SavingDetailPage extends StatefulWidget {
  int id;
  List list;
  SavingDetailPage({Key? key, required this.id, required this.list})
      : super(key: key);

  @override
  State<SavingDetailPage> createState() => _SavingDetailPageState();
}

class _SavingDetailPageState extends State<SavingDetailPage> {
  final _db = CreateDatabase.instance;
  List getSavIndexDashboardList = [];
  bool checkSav = false;
  late TransformationController controller;

  _getSavData() {
    getSavIndexDashboardList = widget.list;
    setState(() {});
  }

  _text(title, text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: ubuntuFamily,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: ubuntuFamily,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.black26,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _getSavData();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        checkSav = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: SavingListPage(
                  id: widget.id,
                ),
              ),
            );
            setState(() {});
          },
        ),
        title: Text(
          "Saving View Item",
          style: TextStyle(
            color: Colors.black,
            fontFamily: ubuntuFamily,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.adaptive.more,
              color: Colors.black,
            ),
            itemBuilder: (a) => [
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: SavingAddEditRecPage(
                          id: widget.id,
                          type: getSavIndexDashboardList[0]["AutoID"],
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 15,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          "Are you sure you want to delete this type?",
                          style: TextStyle(
                            fontFamily: ubuntuFamily,
                          ),
                        ),
                        content: Container(
                          height: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Target Name :",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: ubuntuFamily,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    getSavIndexDashboardList[0]
                                        ["record_remark"],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: ubuntuFamily,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: Colors.black,
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _db.deleteRecordSav(
                                    getSavIndexDashboardList[0]["AutoID"]);
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: SavingPage(id: widget.id),
                                  ),
                                );
                              });
                            },
                            child: Container(
                              color: Colors.black,
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    setState(() {});
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.black,
                        size: 15,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: SavingListPage(
                id: widget.id,
              ),
            ),
          );
          return false;
        },
        child: checkSav == false
            ? const Center(
                child: SpinKitRing(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _text(
                      "Date",
                      DateFormat("dd-MM-yyyy").format(
                        DateTime.parse(
                          getSavIndexDashboardList[0]["record_date"],
                        ),
                      ),
                    ),
                    _text(
                      "Target Name",
                      getSavIndexDashboardList[0]["record_remark"],
                    ),
                    _text(
                      "Amount",
                      NumberFormat.decimalPattern().format(
                        getSavIndexDashboardList[0]["record_price"],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
