// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Pages/bottom_bar.dart';
import 'package:personal_finance/common.dart';
import 'package:personal_finance/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwrodController = TextEditingController();

  final _db = CreateDatabase.instance;

  bool submitted = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Security",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              nameController.clear();
              bool pass2 = true;
              bool loading = false;
              bool submitted = false;
              TextEditingController nameOldPasswordcontroller =
                  TextEditingController();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Form(
                        key: _formKey,
                        autovalidateMode: submitted
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: AlertDialog(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 10,
                            right: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          content: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Change Name",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w500,
                                      fontFamily: ubuntuFamily,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 17,
                                  ),
                                  TextFormField(
                                    controller: nameOldPasswordcontroller,
                                    autovalidateMode: (submitted)
                                        ? AutovalidateMode.always
                                        : AutovalidateMode.disabled,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password can't be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    autofocus: true,
                                    obscureText: pass2,
                                    decoration: InputDecoration(
                                      hintText: "Enter your old passwrod",
                                      hintStyle: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            print(pass2);
                                            pass2 = !pass2;
                                          });
                                        },
                                        icon: (pass2)
                                            ? Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.grey[700],
                                              )
                                            : Icon(
                                                Icons.visibility_off,
                                                color: Colors.grey[700],
                                              ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Name can't be empty!";
                                      } else {
                                        return null;
                                      }
                                    },
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      hintText: "Enter your new name",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            submitted = true;
                                          });
                                          var validate =
                                              _formKey.currentState!.validate();
                                          if (validate) {
                                            setState(() {
                                              loading = true;
                                            });

                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            String? oldPass = await prefs
                                                .getString("password");

                                            if (nameOldPasswordcontroller
                                                    .text ==
                                                oldPass) {
                                              // final user = FirebaseAuth
                                              // .instance.currentUser!;
                                              //  await user
                                              //   .updateDisplayName(
                                              //       nameController.text)
                                              //   .then((value) async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.setString(
                                                  "displayName",
                                                  nameController.text);
                                              // Navigator.popAndPushNamed(
                                              // context, "/main");
                                              setState(() {
                                                loading = false;
                                              });
                                              showSnackbar(
                                                context,
                                                "Name has been successfully changed",
                                                2,
                                                Colors.green[300],
                                              );
                                              // }).catchError((error) {
                                              //   print(error);
                                              //   Navigator.pop(context);

                                              //   setState(() {
                                              //     loading = false;
                                              //   });

                                              //   showSnackbar(
                                              //       context,
                                              //       "Name can't be changed ${error.toString()}",
                                              //       5,
                                              //       Colors.red[300]);
                                              // });
                                              // await user.reload();
                                            } else {
                                              Navigator.pop(context);

                                              setState(() {
                                                loading = false;
                                              });
                                              showSnackbar(
                                                context,
                                                "Your old password is invalid !",
                                                2,
                                                Colors.red[300],
                                              );
                                            }
                                          }
                                        },
                                        child: loading
                                            ? const SizedBox(
                                                width: 10,
                                                height: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text(
                                                "Save",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: securityButton(
              "Change Name",
              const Icon(
                Icons.person,
                color: Colors.amber,
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 0.5,
          ),
          InkWell(
            onTap: () {
              nameController.clear();
              bool pass2 = true;
              bool loading = false;
              bool submitted = false;
              TextEditingController nameOldPasswordcontroller =
                  TextEditingController();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Form(
                        key: _formKey,
                        autovalidateMode: submitted
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: AlertDialog(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 10,
                            right: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          content: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Change Password",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w500,
                                      fontFamily: ubuntuFamily,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 17,
                                  ),
                                  TextFormField(
                                    controller: nameOldPasswordcontroller,
                                    autovalidateMode: (submitted)
                                        ? AutovalidateMode.always
                                        : AutovalidateMode.disabled,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password can't be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    autofocus: true,
                                    obscureText: pass2,
                                    decoration: InputDecoration(
                                      hintText: "Enter your old passwrod",
                                      hintStyle: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            print(pass2);
                                            pass2 = !pass2;
                                          });
                                        },
                                        icon: (pass2)
                                            ? Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.grey[700],
                                              )
                                            : Icon(
                                                Icons.visibility_off,
                                                color: Colors.grey[700],
                                              ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password can't be empty!";
                                      } else {
                                        return null;
                                      }
                                    },
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      hintText: "Enter your new password",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            submitted = true;
                                          });
                                          var validate =
                                              _formKey.currentState!.validate();
                                          if (validate) {
                                            setState(() {
                                              loading = true;
                                            });

                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            String? oldPass = await prefs
                                                .getString("password");

                                            if (nameOldPasswordcontroller
                                                    .text ==
                                                oldPass) {
                                              // final user = FirebaseAuth
                                              // .instance.currentUser!;
                                              //  await user
                                              //   .updateDisplayName(
                                              //       nameController.text)
                                              //   .then((value) async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.setString(
                                                  "displayName",
                                                  nameController.text);
                                              // Navigator.popAndPushNamed(
                                              // context, "/main");
                                              setState(() {
                                                loading = false;
                                              });
                                              showSnackbar(
                                                context,
                                                "Password has been successfully changed!",
                                                2,
                                                Colors.green[300],
                                              );
                                              // }).catchError((error) {
                                              //   print(error);
                                              //   Navigator.pop(context);

                                              //   setState(() {
                                              //     loading = false;
                                              //   });

                                              //   showSnackbar(
                                              //       context,
                                              //       "Name can't be changed ${error.toString()}",
                                              //       5,
                                              //       Colors.red[300]);
                                              // });
                                              // await user.reload();
                                            } else {
                                              Navigator.pop(context);

                                              setState(() {
                                                loading = false;
                                              });
                                              showSnackbar(
                                                context,
                                                "Your old password is invalid !",
                                                2,
                                                Colors.red[300],
                                              );
                                            }
                                          }
                                        },
                                        child: loading
                                            ? const SizedBox(
                                                width: 10,
                                                height: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text(
                                                "Save",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: securityButton(
              "Change Password",
              const Icon(
                Icons.lock,
                color: Colors.red,
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}

Widget securityButton(text, icon) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(),
            )
          ],
        ),
      ),
    ],
  );
}
