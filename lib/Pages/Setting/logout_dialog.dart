// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:personal_finance/Pages/Login/login_page.dart';
import 'package:personal_finance/classes/language_constants.dart';

enum DialogsAction { yes, cancel }

class AlertDialogs {
  static Future<DialogsAction> yesCalcelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: Text(
                // "Cancel",
                translation(context).cancel,
                style: const TextStyle(
                  color: Color(0xFF5463FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginAccountPage(),
                  ),
                );
              },
              child: Text(
                // "Confirm",
                translation(context).com,
                style: const TextStyle(
                  color: Color(0xFFFF1818),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogsAction.cancel;
  }
}
