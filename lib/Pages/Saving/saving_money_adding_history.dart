// ignore_for_file: camel_case_types, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Saving/saving_add_edit_page.dart';
import 'package:personal_finance/Pages/Saving/saving_details_page.dart';
import 'package:personal_finance/Pages/Saving/saving_list.dart';
import 'package:personal_finance/classes/language_constants.dart';
import 'package:personal_finance/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class savingHistory extends StatefulWidget {
  int id;
  int type;
  savingHistory({
    Key? key,
    required this.id,
    required this.type,
  }) : super(key: key);

  @override
  State<savingHistory> createState() => _savingHistoryState();
}

class _savingHistoryState extends State<savingHistory> {
  final _db = CreateDatabase.instance;
  List getAccountList = [];
  List getDataList = [];
  List searchList = [];
  bool check = false;
  bool searchCheck = false;

  _getAcc() async {
    List Data = await _db.getAcc();
    getAccountList = Data;
    setState(() {});
  }

  _getData() async {
    List Data = await _db.getRecordsRem();
    getDataList = Data;
    if (Data.isEmpty) {
      check = true;
    }
    print("/|/////getDataList $getDataList");
    setState(() {});
  }

  saveSavIdInSharePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('saving_history_id', widget.id);
    setState(() {});
  }

  @override
  void initState() {
    _getAcc();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            "History",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              searchCheck == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        "No Search Item",
                        // translation(context).no_srch_itm,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: ubuntuFamily,
                        ),
                      ),
                    )
                  : check == true
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
                          itemCount: getDataList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                right: 16,
                                left: 16,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  List myList = await _db.getRecordRem(
                                    getDataList[index]["AutoID"],
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: SavingDetailPage(
                                        id: widget.id,
                                        list: myList,
                                        type: getDataList[0]["AutoID"],
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
                                                  getDataList[index]
                                                      ["record_remaining"],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: ubuntuFamily,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                      getDataList[index]
                                                          ["record_date"],
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: ubuntuFamily,
                                                    color: Colors.black45,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
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
                                                      child:
                                                          SavingAddEditRecPage(
                                                        id: widget.id,
                                                        type: getDataList[index]
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
                                                                  // "Remaining :",
                                                                  translation(
                                                                          context)
                                                                      .rem,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontFamily:
                                                                        ubuntuFamily,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  getDataList[
                                                                          index]
                                                                      [
                                                                      "record_remaining"],
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
                                                                  translation(
                                                                          context)
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
                                                                  width: 130,
                                                                  child: Text(
                                                                    getDataList[
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
                                                            setState(
                                                              () {
                                                                _db.deleteRecordRem(
                                                                  getDataList[
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
                                                                        id: widget
                                                                            .id),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            color: Colors.black,
                                                            child:
                                                                 Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Text(
                                                                // "Yes",
                                                                translation(context).yes,
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
                                                  children: const [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.black,
                                                      size: 15,
                                                    ),
                                                    SizedBox(),
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
            ],
          ),
        ),
      ),
    );
  }
}
