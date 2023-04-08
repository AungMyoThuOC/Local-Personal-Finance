// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Database/record_map.dart';
import 'package:personal_finance/Pages/Saving/saving_list.dart';
import 'package:personal_finance/Pages/Saving/saving_page.dart';
import 'package:personal_finance/Pages/bottom_bar.dart';
import 'package:personal_finance/common.dart';


class SavingAddEditRecPage extends StatefulWidget {
  int id;
  int type;
  SavingAddEditRecPage({
    Key? key,
    required this.id,
    required this.type,
  }) : super(key: key);

  @override
  State<SavingAddEditRecPage> createState() => _SavingAddEditRecPageState();
}

class _SavingAddEditRecPageState extends State<SavingAddEditRecPage> {
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _amouSavController = TextEditingController();

  bool checkSavAmount = false;
  bool checkSavDelete = false;
  bool checkSavtagName = false;
  bool chooseOut = true;

  bool loading = false;
  final _db = CreateDatabase.instance;
  String checkZero = "";

  _data() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        date = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }

  _addRecord() async {
    var record_map = RecordMap(
      date,
      int.parse(_amouSavController.text),
      _targetController.text,
      checkZero,
    );
    _db.createRecordSav(record_map).then((value) {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: SavingListPage(
          id: widget.id,
        ),
      ),
    );
    setState(() {});
  }

  _editItem() async {
    var record_map = RecordMap(
      date,
      int.parse(_amouSavController.text),
      _targetController,
      checkZero,
    );
    _db.editRecordSav(record_map, widget.type).then((value) {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: SavingListPage(
          id: widget.id,
        ),
      ),
    );
    setState(() {});
  }

  getEditData() async {
    List dataSav = await _db.getRecordSav(widget.type);
    print(">>>>>>>>>> data $dataSav");
    setState(() {
      date = DateFormat("yyyy-MM-dd").format(
        DateTime.parse(
          dataSav[0]["record_date"],
        ),
      );
      _targetController.text = dataSav[0]["record_remark"].toString();
      _amouSavController.text = dataSav[0]["record_price"].toString();
      print(">>>>>>>>>dataSave");
    });
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    getEditData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            widget.type == -1 ? "Saving New Item" : "Saving Edit Item",
            style: TextStyle(
              color: Colors.black,
              fontFamily: ubuntuFamily,
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
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: SavingPage(id: widget.id),
              ),
            );
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(40),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: GestureDetector(
                    onTap: () => _data(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(date),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _targetController,
                        onChanged: (value) {
                          setState(() {
                            if (_targetController.text != "") {
                              checkSavtagName = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Target",
                        ),
                      ),
                      checkSavtagName
                          ? errorTextWidget("Enter Target")
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _amouSavController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp("[0-9]"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (_amouSavController.text != "") {
                              checkSavAmount = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Amount",
                        ),
                      ),
                      checkSavAmount
                          ? errorTextWidget("Enter Amount")
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () {
                      loading = true;
                      if (_targetController.text == "" &&
                          _amouSavController.text == "") {
                        checkSavtagName = true;
                        checkSavAmount = true;
                        loading = false;
                      } else if (_targetController.text == "") {
                        checkSavtagName = true;
                        if (_amouSavController.text == "") {
                          checkSavAmount = true;
                        } else {
                          checkSavAmount = false;
                        }
                        loading = false;
                      } else if (_amouSavController.text == "") {
                        checkSavAmount = true;
                        if (_targetController.text == "") {
                          checkSavtagName = true;
                        } else {
                          checkSavtagName = false;
                        }
                        loading = false;
                      } else {
                        checkSavtagName = false;
                        checkSavAmount = false;
                        if (widget.type == -1) {
                          _addRecord();
                        } else {
                          _editItem();
                        }
                      }
                      setState(() {});
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Center(
                        child: loading == true
                            ? const SizedBox(
                                width: 23,
                                height: 23,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Save Item",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: ubuntuFamily,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
