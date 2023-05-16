// ignore_for_file: must_be_immutable, non_constant_identifier_names, unnecessary_this, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Database/record_map.dart';
import 'package:personal_finance/Pages/Outcome/outcome.dart';
import 'package:personal_finance/common.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class OutAddAndEditRecPage extends StatefulWidget {
  int id;
  int type;
  OutAddAndEditRecPage({
    Key? key,
    required this.type,
    required this.id,
  }) : super(key: key);

  @override
  _OutAddAndEditRecPageState createState() => _OutAddAndEditRecPageState();
}

class _OutAddAndEditRecPageState extends State<OutAddAndEditRecPage> {
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final TextEditingController _amountOutController = TextEditingController();
  final TextEditingController _remarkOutController = TextEditingController();
  // final TextEditingController _categoryController = TextEditingController();

  String? _selected;

  List<dynamic> myJson = [];

  bool checkOutAmount = false;
  bool checkOutDelete = false;
  bool checkOutCatName = false;
  // int indexOne = 0;
  // int iconNum = 0;
  // String catName = '';
  bool chooseOut = true;
  int stateOut = 0;
  int numOut = 0;
  int resultOUt = 0;

  bool loading = false;
  final _db = CreateDatabase.instance;
  String checkZero = "";

  _date() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        date = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  _addRecord() async {
    var record_map = RecordMap(
      date,
      int.parse(_amountOutController.text),
      _remarkOutController.text,
      // _selected ?? "phone",
      checkZero,
    );
    _db.createRecordOut(record_map).then((value) {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: OutcomePage(
          id: widget.id,
        ),
      ),
    );
    setState(() {});
  }

  _editItem() async {
    var record_map = RecordMap(
      date,
      int.parse(_amountOutController.text),
      _remarkOutController.text,
      // _selected ?? "phone",
      checkZero,
    );
    _db.editRecordOut(record_map, widget.type).then((value) {
      loading = false;
    });
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: OutcomePage(
          id: widget.id,
        ),
      ),
    );
    setState(() {});
  }

  getEditData() async {
    List dataOut = await _db.getRecordOut(widget.type);
    print(">>>>>>>>>>>>>>>> dataOut $dataOut");
    setState(() {
      date = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(dataOut[0]["record_date"]));
      _amountOutController.text = dataOut[0]["record_price"].toString();
      _remarkOutController.text = dataOut[0]["record_remark"].toString();
      ////
      print(">>>>>>>>>>>>>>dataOut");
    });
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    getEditData();
    this.myJson.add(
      {"val": '1', "image": "assets/images/account.png", "name": "Bank"},
    );
    this.myJson.add(
      {"val": '2', "image": "assets/images/card.png", "name": "Credit Card"},
    );
    this.myJson.add(
      {"val": '3', "image": "assets/images/cart.png", "name": "Cart"},
    );
    this.myJson.add(
      {"val": '4', "image": "assets/images/iphone.png", "name": "Phone"},
    );
    this.myJson.add(
      {"val": '5', "image": "assets/images/laptop.png", "name": "Laptop"},
    );
    this.myJson.add(
      {"val": '6', "image": "assets/images/mone.png", "name": "Monetization"},
    );
    this.myJson.add(
      {"val": '7', "image": "assets/images/newpaper.png", "name": "Newpaper"},
    );
    this.myJson.add(
      {"val": '8', "image": "assets/images/gitcard.png", "name": "Gift"},
    );
    // this.myJson.add(
    //   {"val": '9', "image": "assets/images/piza.png", "name": "Pizza"},
    // );
    this.myJson.add(
      {"val": '10', "image": "assets/images/shopping.png", "name": "Shopping"},
    );
    this.myJson.add(
      {
        "val": '11',
        "image": "assets/images/wallet.png",
        "name": "Balance Wallet"
      },
    );

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
          elevation: 0,
          title: Text(
            widget.type == -1 ? "New Item" : "Edit Item",
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
                  child: OutcomePage(
                    id: widget.id,
                  ),
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
                child: OutcomePage(
                  id: widget.id,
                ),
              ),
            );
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(40),
                // _titleTextWidget("Date"),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: GestureDetector(
                    onTap: () => _date(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all()),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat("dd-MM-yyyy")
                                    .format(DateTime.parse(date)),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
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
                // _titleTextWidget("Amount"),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _amountOutController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[0-9]'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (_amountOutController.text != "") {
                              checkOutAmount = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Amount",
                          // focusedBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.black26),
                          // ),
                          // enabledBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.black26),
                          // ),
                        ),
                      ),
                      checkOutAmount
                          ? errorTextWidget("Enter Amount")
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // _titleTextWidget("Remark"),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: _remarkOutController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: "Remark",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isDense: true,
                                hint: const Text("Select category"),
                                value: _selected,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selected = newValue!;
                                  });

                                  print(_selected);
                                },
                                items: myJson.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category["val"].toString(),
                                    // value: _mySelection,
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(
                                          category["image"],
                                          width: 25,
                                        ),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(category["name"])),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        loading = true;
                        if (_amountOutController.text == "") {
                          checkOutAmount = true;
                          loading = false;
                        } else {
                          checkOutAmount = false;
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
