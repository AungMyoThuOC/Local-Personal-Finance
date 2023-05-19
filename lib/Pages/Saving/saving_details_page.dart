// ignore_for_file: must_be_immutable, sized_box_for_whitespace, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Saving/saving_list.dart';
import 'package:personal_finance/Pages/Saving/saving_money_adding.dart';
import 'package:personal_finance/Pages/Saving/saving_money_adding_history.dart';
import 'package:personal_finance/classes/language_constants.dart';
import 'package:personal_finance/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingDetailPage extends StatefulWidget {
  int id;
  List list;
  int type;
  SavingDetailPage({
    Key? key,
    required this.id,
    required this.list,
    required this.type,
  }) : super(key: key);

  @override
  State<SavingDetailPage> createState() => _SavingDetailPageState();
}

class _SavingDetailPageState extends State<SavingDetailPage> {
  final _db = CreateDatabase.instance;
  List getSavIndexDashboardList = [];
  bool checkSav = false;
  bool loading = false;
  List getDataList = [];
  List searchList = [];
  bool searchCheck = false;
  late TransformationController controller;
  TextEditingController remainingController = TextEditingController();
  bool checkRem = false;

  _getSaveData() {
    getSavIndexDashboardList = widget.list;
    setState(() {});
  }

  _getData() async {
    List data = await _db.getRecordsRem();
    getDataList = data;
    if (data.isEmpty) {
      checkRem = true;
    }
    print(">>>>>>>>>>>>>> getSAVDETAILDataList : $getDataList");
    setState(() {});
  }

  saveIdInSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('saving_details', widget.id);
    setState(() {});
  }

  getEditData() async {
    List data = await _db.getRecordRem(widget.type);
    print(">>>>>>>> data $data");
    setState(() {
      remainingController.text = data[0]["record_price"].toString();
      setState(() {});
    });
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {});
    });
  }

  _text(title, text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
      ),
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
    _getSaveData();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        checkSav = true;
      });
    });
    _getData();
    getEditData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddSavingMoney(
                id: widget.id,
                type: widget.type,
                list: [],
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          // "View",
          translation(context).view,
          style: TextStyle(
            color: Colors.black,
            fontFamily: ubuntuFamily,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => savingHistory(
                    id: widget.id,
                    type: widget.type,
                  ),
                ),
              );
              setState(() {});
            },
            icon: const Icon(
              Icons.history,
              color: Colors.black,
            ),
          ),
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
                    CircularPercentIndicator(
                      progressColor: const Color(0xFF000000),
                      radius: 60.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: 0.5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder(
                          // stream: ,
                          builder: (context, snapshot) {
                            // _db.getRecordSav(
                            //   getDataList[0]["AutoID"],
                            // );
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            // var ds = snapshot.data!;
                            double sum = 0.0;

                            // for (int i = 0; i < getDataList.length; i++)
                            //   sum += (getDataList[i]["amount"]).toDouble();

                            // return Text("Remaining/Total");
                            return Text(
                              '${sum}/${getSavIndexDashboardList[0]["record_price"]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: ubuntuFamily,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _text(
                      // "Date",
                      translation(context).dat,
                      DateFormat("dd-MM-yyyy").format(
                        DateTime.parse(
                          getSavIndexDashboardList[0]["record_date"],
                        ),
                      ),
                    ),
                    _text(
                      // "Target Name",
                      translation(context).trg_nam,
                      getSavIndexDashboardList[0]["record_remark"],
                    ),
                    _text(
                      // "Amount",
                      translation(context).amount,
                      NumberFormat.decimalPattern().format(
                        getSavIndexDashboardList[0]["record_price"],
                      ),
                    ),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                left: 15,
                                right: 15,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        // "Remaining",
                                        translation(context).remaining,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: ubuntuFamily,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: StreamBuilder(
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }

                                            // var db = snapshot.data!;

                                            double sum = 0.0;

                                            // for (int i = 0; i < db; i++)

                                            return Text(
                                              '${getSavIndexDashboardList[0]["record_price"] - sum}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily: ubuntuFamily,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // Container(
                                      //   width:
                                      //       MediaQuery.of(context).size.width *
                                      //           0.4,
                                      //   child: Text(
                                      //     "",
                                      //     style: TextStyle(
                                      //       color: Colors.black,
                                      //       fontSize: 18,
                                      //       fontFamily: ubuntuFamily,
                                      //       overflow: TextOverflow.ellipsis,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    color: Colors.black26,
                                    thickness: 0.5,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    // _text(
                    //   "Remaing",
                    //   NumberFormat.decimalPattern().format(
                    //     getSavIndexDashboardList[0]["record_price"],
                    //   ),
                    // ),
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
