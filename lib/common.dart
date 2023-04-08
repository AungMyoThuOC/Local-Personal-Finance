// ignore_for_file: must_be_immutable, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';

String ubuntuFamily = "Ubuntu";

void showToast(BuildContext context, String massage) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      duration: (const Duration(seconds: 1)),
      content: Text(massage),
    ),
  );
}

class PreviewImageDialog extends StatelessWidget {
  String imagePath;
  PreviewImageDialog({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 10,
        child: Image.file(
          File(imagePath),
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

errorTextWidget(errorText) {
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Text(
      errorText,
      style: TextStyle(
        color: Colors.red,
        fontFamily: ubuntuFamily,
      ),
    ),
  );
}
