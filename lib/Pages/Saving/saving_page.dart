import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Pages/Saving/saving_list.dart';

class SavingPage extends StatefulWidget {
  int id;
  SavingPage({Key? key, required this.id}) : super(key: key);

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Saving",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
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
              },
              icon: const Icon(
                FluentSystemIcons.ic_fluent_add_regular,
                color: Colors.black,
              ),
              splashRadius: 2,
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
