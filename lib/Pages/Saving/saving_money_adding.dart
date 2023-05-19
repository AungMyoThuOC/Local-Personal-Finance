// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Database/record_map.dart';
import 'package:personal_finance/Database/remaining_map.dart';
import 'package:personal_finance/Pages/Saving/saving_money_adding_history.dart';
import 'package:personal_finance/classes/language_constants.dart';

class AddSavingMoney extends StatefulWidget {
  List list;
  int id;
  int type;

  AddSavingMoney({
    Key? key,
    required this.id,
    required this.list,
    required this.type,
  }) : super(key: key);

  @override
  State<AddSavingMoney> createState() => _AddSavingMoneyState();
}

class _AddSavingMoneyState extends State<AddSavingMoney> {
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  TextEditingController amountcontroller = TextEditingController();
  final TextEditingController _remarkOutController = TextEditingController();
  String checkZero = "";

  // ignore: prefer_final_fields
  bool _submitted = false;
  List getIndexDashboardList = [];
  final _formKey = GlobalKey<FormState>();
  int? languageCode;
  List getSavDataList = [];
  final _db = CreateDatabase.instance;
  bool check = false;
  bool loading = false;
  bool checkAmount = false;

  _addRecord() async {
    var record_map = RecordMap(
      date,
      int.parse(amountcontroller.text),
      _remarkOutController.text,
      checkZero,
    );
    _db.createRecordREm(record_map).then((value) {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: savingHistory(
          id: widget.id,
          type: widget.type,
        ),
      ),
    );
    setState(() {});
  }

  editRecord() async {
    var remaining_map = RemainingMap(
      int.parse(amountcontroller.text),
    );
    // _db.editRecordREM(remaining_map, widget.type).then((value) {
    //   loading = false;
    // });
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: savingHistory(
          id: widget.id,
          type: widget.type,
        ),
      ),
    );
    setState(() {});
  }

  _getData() {
    getIndexDashboardList = widget.list;
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        check = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            "Add money for ${widget.type}",
            // "Add money for ${getIndexDashboardList[0]["record_remark"].toString()}",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 10,
                      left: 3,
                    ),
                    child: Text(
                      // "Amount",
                      translation(context).amount,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextFormField(
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: amountcontroller,
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "0") {
                        return "Please enter amount";
                      }
                      // else if (int.parse(value) + widget.id > widget.type) {
                      //   return "Your add price is over your target price";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: "Enter your Amount",
                      hintStyle: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.grey[700],
                            side: const BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            // "Cancel",
                            translation(context).cancel,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            loading = true;
                            if (amountcontroller.text == "") {
                              checkAmount = true;
                              loading = false;
                            } else {
                              checkAmount = false;
                              if (widget.type == -1) {
                                _addRecord();
                              } else {
                                editRecord();
                              }
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.blue[600],
                          ),
                          child: Text(
                            // "Add",
                            translation(context).add,
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
      ),
    );
  }
}
