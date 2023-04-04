// ignore_for_file: must_be_immutable, avoid_print, sized_box_for_whitespace

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Outcome/out_add_edit_rec_page.dart';
import 'package:personal_finance/Pages/Outcome/out_details_page.dart';
import 'package:personal_finance/Pages/bottom_bar.dart';

import 'package:personal_finance/common.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutcomePage extends StatefulWidget {
  int id;
  OutcomePage({Key? key, required this.id, this.selected}) : super(key: key);

  String? selected;

  @override
  State<OutcomePage> createState() => _OutcomePageState();
}

class _OutcomePageState extends State<OutcomePage> {
  final _db = CreateDatabase.instance;
  List getOutAccountList = [];
  List getOutDataList = [];
  List searchOutList = [];
  bool checkOut = false;
  bool searchOutCheck = false;

  _getOutAcc() async {
    List dataOut = await _db.getAcc();
    getOutAccountList = dataOut;
    setState(() {});
  }

  _getOutData() async {
    List dataOut = await _db.getRecordsOut();
    getOutDataList = dataOut;
    if (dataOut.isEmpty) {
      checkOut = true;
    }
    print(">>>>>>>>>>>>>> getOutDataList : $getOutDataList");
    setState(() {});
  }

  saveOutIdInSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('outcome_id', widget.id);
    setState(() {});
  }

  @override
  void initState() {
    _getOutAcc();
    _getOutData();
    // saveIdInSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          // elevation: 0,
          // backgroundColor: Colors.transparent,
          // centerTitle: false,
          automaticallyImplyLeading: false,
          title: const Text(
            "Outcome",
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: const BottomBar(),
                ),
              );
              setState(() {});
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: OutAddAndEditRecPage(
                        // add Outcome
                        id: widget.id,
                        type: -1,
                      ),
                    ));
                setState(() {});
              },
              icon: const Icon(
                FluentSystemIcons.ic_fluent_add_regular,
                color: Colors.black,
              ),
              splashRadius: 2,
            ),
          ],
          centerTitle: true,
          // elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                searchOutList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchOutList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              right: 16,
                              left: 16,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                List myList = await _db.getRecordOut(
                                    searchOutList[index]["AutoID"]);
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: OutDetailPage(
                                      id: widget.id,
                                      list: myList,
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                              child: Card(
                                // color: Color.fromARGB(255, 255, 255, 255),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 85,
                                            child: Text(
                                              searchOutList[index]
                                                  ["record_remark"],
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: ubuntuFamily,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            width: 85,
                                            child: Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                DateTime.parse(
                                                  searchOutList[index]
                                                      ["record_date"],
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: ubuntuFamily,
                                                color: Colors.black45,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      PopupMenuButton(
                                        itemBuilder: (a) => [
                                          PopupMenuItem(
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    child: OutAddAndEditRecPage(
                                                      id: widget.id,
                                                      type: searchOutList[index]
                                                          ["AutoID"],
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
                                                      "Are you sure you want to delete this type?",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            ubuntuFamily,
                                                      ),
                                                    ),
                                                    content: Container(
                                                      height: 60,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Remark : ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      ubuntuFamily,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                searchOutList[
                                                                        index][
                                                                    "record_remark"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      ubuntuFamily,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Date : ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      ubuntuFamily,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Container(
                                                                width: 130,
                                                                child: Text(
                                                                  searchOutList[
                                                                          index]
                                                                      [
                                                                      "record_date"],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontFamily:
                                                                        ubuntuFamily,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          color: Colors.black,
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _db.deleteRecordOut(
                                                                searchOutList[
                                                                        index]
                                                                    ["AutoID"]);
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeft,
                                                                child:
                                                                    OutcomePage(
                                                                  id: widget.id,
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                        },
                                                        child: Container(
                                                          color: Colors.black,
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
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
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : searchOutCheck == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Text(
                              "No search item",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontFamily: ubuntuFamily,
                              ),
                            ),
                          )
                        : checkOut == true
                            ? Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Text(
                                  "No item",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                    fontFamily: ubuntuFamily,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: getOutDataList.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      right: 16,
                                      left: 16,
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        List myList = await _db.getRecordOut(
                                            getOutDataList[index]["AutoID"]);
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: OutDetailPage(
                                              id: widget.id,
                                              list: myList,
                                            ),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      child: Card(
                                        // color: Color.fromARGB(255, 255, 255, 255),
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 85,
                                                    child: Text(
                                                      getOutDataList[index]
                                                          ["record_remark"],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            ubuntuFamily,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Container(
                                                    width: 85,
                                                    child: Text(
                                                      DateFormat("dd-MM-yyyy")
                                                          .format(
                                                        DateTime.parse(
                                                          getOutDataList[index]
                                                              ["record_date"],
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                            ubuntuFamily,
                                                        color: Colors.black45,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              PopupMenuButton(
                                                itemBuilder: (a) => [
                                                  PopupMenuItem(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .rightToLeft,
                                                            child:
                                                                OutAddAndEditRecPage(
                                                              id: widget.id,
                                                              type:
                                                                  getOutDataList[
                                                                          index]
                                                                      [
                                                                      "AutoID"],
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
                                                              color:
                                                                  Colors.black,
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
                                                          builder: (_) =>
                                                              AlertDialog(
                                                            title: Text(
                                                              "Are you sure you want to delete this type?",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    ubuntuFamily,
                                                              ),
                                                            ),
                                                            content: Container(
                                                              height: 60,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Remark : ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontFamily:
                                                                              ubuntuFamily,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        getOutDataList[index]
                                                                            [
                                                                            "record_remark"],
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontFamily:
                                                                              ubuntuFamily,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Date : ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontFamily:
                                                                              ubuntuFamily,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            130,
                                                                        child:
                                                                            Text(
                                                                          getOutDataList[index]
                                                                              [
                                                                              "record_date"],
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontFamily:
                                                                                ubuntuFamily,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
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
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .black,
                                                                  child:
                                                                      const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            15),
                                                                    child: Text(
                                                                      "No",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white70,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _db.deleteRecordOut(
                                                                        getOutDataList[index]
                                                                            [
                                                                            "AutoID"]);
                                                                    Navigator
                                                                        .pushReplacement(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .rightToLeft,
                                                                        child:
                                                                            OutcomePage(
                                                                          id: widget
                                                                              .id,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .black,
                                                                  child:
                                                                      const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            15),
                                                                    child: Text(
                                                                      "Yes",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
