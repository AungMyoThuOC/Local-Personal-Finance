// ignore_for_file: must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Database/remaining_map.dart';
import 'package:personal_finance/Pages/Saving/saving_add_edit_page.dart';
import 'package:personal_finance/Pages/Saving/saving_list.dart';
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
  bool loading = false;
  late TransformationController controller;
  TextEditingController sliderController = TextEditingController();
  bool checkRem = false;

  _getSavData() {
    getSavIndexDashboardList = widget.list;
    setState(() {});
  }

  _addRecord() async {
    var remaining_map = RemainingMap(
      int.parse(sliderController.text),
    );
    _db.createRecordSAV(remaining_map).then((value) {
      loading = false;
    });
    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) => SavingDetailPage(
          id: widget.id,
          list: [],
        ),
      ),
    );
  }

  _editItem() async {
    var remaining_map = RemainingMap(
      int.parse(sliderController.text),
    );
    _db.createRecordSAV(remaining_map).then((value) {
      loading = false;
    });
    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) => SavingDetailPage(
          id: widget.id,
          list: [],
        ),
      ),
    );
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

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.only(top: 10.0),
              title: const Text(
                "Add Remaining",
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
              ),
              content: Container(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Amount",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        controller: sliderController,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        bottom: 15.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            32.0,
                          ),
                          bottomRight: Radius.circular(
                            32.0,
                          ),
                        ),
                      ),
                      // child: const Text(
                      //   "Save",
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      child: GestureDetector(
                        onTap: () {
                          loading = true;
                          if (sliderController.text == "") {}
                        },
                        child: Container(
                          // color: Colors.black,
                          child: Center(
                              child: loading == true
                                  ? const SizedBox(
                                      // width: 23,
                                      // height: 23,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: ubuntuFamily,
                                      ),
                                    )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
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
                                    child: SavingListPage(
                                      id: widget.id,
                                    ),
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
                      progressColor: Color(0xFF000000),
                      radius: 60.0,
                      lineWidth: 13.0,
                      animation: true,
                      percent: 0.5,
                    ),
                    Column(
                      children: const [
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                                        "Remaining",
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
                                        child: Text(
                                          "",
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
