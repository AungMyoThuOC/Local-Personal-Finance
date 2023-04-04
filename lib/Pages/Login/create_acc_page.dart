// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_finance/Database/create_acc_map.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/Home/home_page.dart';
import 'package:personal_finance/Pages/Login/register_or_login_page.dart';
import 'package:personal_finance/Pages/bottom_bar.dart';
import 'package:personal_finance/common.dart';
import 'package:page_transition/page_transition.dart';

class CreateAccountPage extends StatefulWidget {
  int checkPage;
  int id;
  CreateAccountPage({Key? key, required this.checkPage, required this.id})
      : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool checkName = false;
  bool checkPhone = false;
  bool checkPassword = false;
  bool checkObscureText = true;
  final _db = CreateDatabase.instance;
  List getAccountList = [];
  String checkZero = "";

  Future<void> _createAccount() async {
    if (_phoneNoController.text.startsWith("0")) {
      checkZero = "true";
    } else {
      checkZero = "false";
    }
    var acc_map = AccMap(
      _nameController.text,
      int.parse(_phoneNoController.text),
      _passwordController.text,
      // image_path,
      checkZero,
    );
    _db.createAcc(acc_map);
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const BottomBar(
            // id: 1,
            ),
      ),
    );
    setState(() {});
  }

  Future<void> _editAccount() async {
    if (_phoneNoController.text.startsWith("0")) {
      checkZero = "true";
    } else {
      checkZero = "false";
    }
    var acc_map = AccMap(
      _nameController.text,
      int.parse(_phoneNoController.text),
      _passwordController.text,
      // image_path,
      checkZero,
    );
    _db.editAcc(acc_map, getAccountList[0]["AutoID"]);
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const BottomBar(
            // id: 1,
            ),
      ),
    );
    setState(() {});
  }

  _checkPage() async {
    if (widget.checkPage == 1) {
      List data = await _db.getAcc();
      getAccountList = data;
      print(">>>>>>>>>>>>>>>> $getAccountList");
      _nameController.text = getAccountList[0]["name"];
      _phoneNoController.text = getAccountList[0]["checkZero"] == "true"
          ? "0${getAccountList[0]["phonenum"]}"
          : getAccountList[0]["phonenum"].toString();
      _passwordController.text = getAccountList[0]["password"].toString();
      // image_path = getAccountList[0]["image"];
    }
    setState(() {});
  }

  @override
  void initState() {
    _checkPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: widget.id == 2
                      ? const RegisterOrLoginPage()
                      : HomePage(id: widget.id),
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
                child: widget.id == 2
                    ? const RegisterOrLoginPage()
                    : HomePage(id: widget.id),
              ),
            );
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {
                            if (_nameController.text != "") {
                              checkName = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Name",
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          // focusedBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.black26),
                          // ),
                          // enabledBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.black26),
                          // ),
                        ),
                      ),
                      checkName ? errorTextWidget("Enter name") : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _phoneNoController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[0-9]'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (_phoneNoController.text != "") {
                              checkPhone = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Phone number",
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          // focusedBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.black26),
                          // ),
                          // enabledBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.black26),
                          // ),
                        ),
                      ),
                      checkPhone
                          ? errorTextWidget("Enter phone number")
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _passwordController,
                        obscureText: checkObscureText,
                        onChanged: (value) {
                          setState(() {
                            if (_passwordController.text != "") {
                              checkPassword = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          // focusedBorder: const UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.black26),
                          // ),
                          // enabledBorder: const UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.black26),
                          // ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              checkObscureText = !checkObscureText;
                              setState(() {});
                            },
                            icon: Icon(
                              checkObscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      checkPassword
                          ? errorTextWidget("Enter password")
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      if (_nameController.text == "" &&
                          _phoneNoController.text == "" &&
                          _passwordController.text == "") {
                        checkName = true;
                        checkPhone = true;
                        checkPassword = true;
                      } else if (_nameController.text == "") {
                        checkName = true;
                        if (_phoneNoController.text == "") {
                          checkPhone = true;
                        } else {
                          checkPhone = false;
                        }
                        if (_passwordController.text == "") {
                          checkPassword = true;
                        } else {
                          checkPassword = false;
                        }
                      } else if (_phoneNoController.text == "") {
                        checkPhone = true;
                        if (_nameController.text == "") {
                          checkName = true;
                        } else {
                          checkName = false;
                        }
                        if (_passwordController.text == "") {
                          checkPassword = true;
                        } else {
                          checkPassword = false;
                        }
                      } else if (_passwordController.text == "") {
                        checkPassword = true;
                        if (_phoneNoController.text == "") {
                          checkPhone = true;
                        } else {
                          checkPhone = false;
                        }
                        if (_nameController.text == "") {
                          checkName = true;
                        } else {
                          checkName = false;
                        }
                      } else {
                        checkName = false;
                        checkPhone = false;
                        checkPassword = false;
                        if (_passwordController.text.length < 4) {
                          showToast(context,
                              "Password must have at least 4 charactor!");
                        } else if (_phoneNoController.text.length < 7) {
                          showToast(context,
                              "Phone number must have at least 7 charactor!");
                        } else {
                          if (widget.checkPage == 0) {
                            _createAccount();
                          } else {
                            _editAccount();
                          }
                        }
                      }
                      setState(() {});
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          widget.checkPage == 0 ? "Create" : "Save",
                          style: const TextStyle(
                            color: Colors.white,
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
