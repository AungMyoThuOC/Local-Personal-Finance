// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Saving/saving_add_edit_page.dart';
import 'package:personal_finance/Pages/Saving/saving_details_page.dart';
import 'package:personal_finance/Pages/bottom_bar.dart';
import 'package:personal_finance/classes/language_constants.dart';
import 'package:personal_finance/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingListPage extends StatefulWidget {
  int id;
  SavingListPage({Key? key, required this.id}) : super(key: key);

  @override
  State<SavingListPage> createState() => _SavingListPageState();
}

class _SavingListPageState extends State<SavingListPage> {
  final _db = CreateDatabase.instance;
  List getSavAccountList = [];
  List getSavDataList = [];
  List searchSavList = [];
  bool checkSav = false;
  bool searchCheckSav = false;

  _getSavAcc() async {
    List SavData = await _db.getAcc();
    getSavAccountList = SavData;
    setState(() {});
  }

  _getSavData() async {
    List SavData = await _db.getRecordsSav();
    getSavDataList = SavData;
    if (SavData.isEmpty) {
      checkSav = true;
    }
    print(">>>>>>>> getSavDataList: $getSavDataList");
    setState(() {});
  }

  saveSavIdInSharePreFerences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('saving_id', widget.id);
    setState(() {});
  }

  @override
  void initState() {
    _getSavAcc();
    _getSavData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            // "List",
            translation(context).list,
            style: const TextStyle(
              color: Colors.black,
            ),
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
                    child: SavingAddEditRecPage(
                      id: widget.id,
                      type: -1,
                    ),
                  ),
                );
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
                const SizedBox(
                  height: 20,
                ),
                searchSavList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchSavList.length,
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
                                List myList = await _db.getRecordSav(
                                  searchSavList[index]["AutoID"],
                                );
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: SavingDetailPage(
                                      id: widget.id,
                                      list: myList,
                                      type: getSavDataList[0]["AutoID"],
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
                                              searchSavList[index]
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
                                                  searchSavList[index]
                                                      ["record_date"],
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: ubuntuFamily,
                                                color: Colors.black,
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
                                                    child: SavingAddEditRecPage(
                                                      id: widget.id,
                                                      type: searchSavList[index]
                                                          ["AutoID"],
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
                                                      // "Do you want to delete?",
                                                      translation(context)
                                                          .d_y_w_t_d,
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
                                                                // "Target Name :",
                                                                translation(
                                                                        context)
                                                                    .trg_nae,
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
                                                                searchSavList[
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
                                                                // "Date :",
                                                                translation(
                                                                        context)
                                                                    .date,
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
                                                                  searchSavList[
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
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: Text(
                                                              // "No",
                                                              translation(
                                                                      context)
                                                                  .no,
                                                              style:
                                                                  const TextStyle(
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
                                                            _db.deleteRecordSav(
                                                              searchSavList[
                                                                      index]
                                                                  ["AutoID"],
                                                            );
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeft,
                                                                child: SavingListPage(
                                                                    id: widget
                                                                        .id),
                                                              ),
                                                            );
                                                          });
                                                        },
                                                        child: Container(
                                                          color: Colors.black,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: Text(
                                                              // "Yes",
                                                              translation(
                                                                      context)
                                                                  .yes,
                                                              style:
                                                                  const TextStyle(
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
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : searchCheckSav == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Text(
                              "No Search Item",
                              // translation(context).no_srch_itm,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontFamily: ubuntuFamily,
                              ),
                            ),
                          )
                        : checkSav == true
                            ? Center(
                                child: Text(
                                  // "No price has been added.",
                                  translation(context).no_pric_ha_ben_add,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                    fontFamily: ubuntuFamily,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: getSavDataList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      right: 16,
                                      left: 16,
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        List mysavList = await _db.getRecordSav(
                                          getSavDataList[index]["AutoID"],
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: SavingDetailPage(
                                              id: widget.id,
                                              list: mysavList,
                                              type: getSavDataList[0]["AutoID"],
                                            ),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      child: Card(
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 85,
                                                      child: Text(
                                                        getSavDataList[index]
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
                                                            getSavDataList[
                                                                    index]
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
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          LinearPercentIndicator(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            135,
                                                        animation: true,
                                                        lineHeight: 12.0,
                                                        animationDuration: 2000,
                                                        percent: 0.5,
                                                        barRadius: const Radius
                                                            .circular(10),
                                                        center: const Text(
                                                          "50.0%",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        linearStrokeCap:
                                                            LinearStrokeCap
                                                                .roundAll,
                                                        progressColor:
                                                            const Color(
                                                                0xFF000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                                                SavingAddEditRecPage(
                                                              id: widget.id,
                                                              type:
                                                                  getSavDataList[
                                                                          index]
                                                                      [
                                                                      "AutoID"],
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
                                                            translation(context)
                                                                .edit,
                                                            style:
                                                                const TextStyle(
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
                                                              // "Do you want to delete?",
                                                              translation(
                                                                      context)
                                                                  .d_y_w_t_d,
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
                                                                        // "Target Name :",
                                                                        translation(context)
                                                                            .trg_nae,
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
                                                                        getSavDataList[index]
                                                                            [
                                                                            "record_remark"],
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontFamily:
                                                                              ubuntuFamily,
                                                                        ),
                                                                      )
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
                                                                        // "Date :",
                                                                        translation(context)
                                                                            .date,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontFamily:
                                                                              ubuntuFamily,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            130,
                                                                        child:
                                                                            Text(
                                                                          getSavDataList[index]
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
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            15),
                                                                    child: Text(
                                                                      // "No",
                                                                      translation(
                                                                              context)
                                                                          .no,
                                                                      style:
                                                                          const TextStyle(
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
                                                                    _db.deleteRecordSav(
                                                                      getSavDataList[
                                                                              index]
                                                                          [
                                                                          "AutoID"],
                                                                    );
                                                                    Navigator
                                                                        .pushReplacement(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .rightToLeft,
                                                                        child: SavingListPage(
                                                                            id: widget.id),
                                                                      ),
                                                                    );
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .black,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            15),
                                                                    child: Text(
                                                                      // "Yes",
                                                                      translation(
                                                                              context)
                                                                          .yes,
                                                                      style:
                                                                          const TextStyle(
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
                                                            translation(context)
                                                                .delete,
                                                            style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
