// ignore_for_file: must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Outcome/out_add_edit_rec_page.dart';
import 'package:personal_finance/Pages/outcome/outcome.dart';
import 'package:personal_finance/classes/language_constants.dart';
import 'package:personal_finance/common.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class OutDetailPage extends StatefulWidget {
  int id;
  List list;
  OutDetailPage({
    Key? key,
    required this.id,
    required this.list,
  }) : super(key: key);

  @override
  State<OutDetailPage> createState() => _OutDetailPageState();
}

class _OutDetailPageState extends State<OutDetailPage> {
  final _db = CreateDatabase.instance;
  List getIndexDashboardListOut = [];

  bool checkOut = false;
  late TransformationController controller;

  _getData() {
    getIndexDashboardListOut = widget.list;
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
    _getData();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        checkOut = true;
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
                child: OutcomePage(
                  id: widget.id,
                ),
              ),
            );
            setState(() {});
          },
        ),
        title: Text(
          // "View",
          translation(context).view,
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
                        child: OutAddAndEditRecPage(
                          id: widget.id,
                          type: getIndexDashboardListOut[0]["AutoID"],
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        // "Edit",
                        translation(context).edit,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
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
                          // "Do you want to delete?",
                          translation(context).d_y_w_t_d,
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
                                    // "Amount : ",
                                    translation(context).amount,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: ubuntuFamily,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    getIndexDashboardListOut[0]["record_price"],
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    // "Date : ",
                                    translation(context).date,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: ubuntuFamily,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 130,
                                    child: Text(
                                      getIndexDashboardListOut[0]
                                          ["record_date"],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: ubuntuFamily,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
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
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  // "No",
                                  translation(context).no,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _db.deleteRecordOut(
                                    getIndexDashboardListOut[0]["AutoID"]);
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: OutcomePage(
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              });
                            },
                            child: Container(
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  // "Yes",
                                  translation(context).yes,
                                  style: const TextStyle(
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
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.black,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        // "Delete",
                        translation(context).delete,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: OutcomePage(
                id: widget.id,
              ),
            ),
          );
          return false;
        },
        child: checkOut == false
            ? const Center(
                child: SpinKitRing(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _text(
                      // "Date",
                      translation(context).dat,
                      DateFormat("dd-MM-yyyy").format(
                        DateTime.parse(
                          getIndexDashboardListOut[0]["record_date"],
                        ),
                      ),
                    ),
                    _text(
                        // "Amount",
                        translation(context).amount,
                        NumberFormat.decimalPattern()
                            .format(getIndexDashboardListOut[0]["record_price"])
                            .toString()),
                    _text(
                      // "Remark",
                      translation(context).rmk,
                      getIndexDashboardListOut[0]["record_remark"],
                    ),
                    // _text("Category", getIndexDashboardListOut[0]["record_cat"]),
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
