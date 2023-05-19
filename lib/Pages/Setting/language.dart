import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Pages/bottom_bar.dart';
import 'package:personal_finance/classes/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  int selectedLang = 1;

  getLang() async {
    final prefs = await SharedPreferences.getInstance();
    final int? lang = prefs.getInt('language');
    setState(() {
      selectedLang = (lang == null) ? 1 : lang;
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          // "Language",
          translation(context).language,
          style: const TextStyle(
            color: Colors.black,
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
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            RadioListTile<int>(
              value: 1,
              groupValue: selectedLang,
              title: const Text(
                "English",
              ),
              onChanged: (value) async {
                // Image.asset(
                //   "assets/images/Myanmar.png",
                // );
                final prefs = await SharedPreferences.getInstance();
                prefs.setInt('language', 1);
                setState(() {
                  selectedLang = 1;
                });
              },
            ),
            const Divider(
              thickness: 0.5,
            ),
            // Row(
            //   children: [
            //     Image.asset(
            //       "assets/images/Myanmar.png",
            //       width: 50,
            //       height: 50,
            //     ),
            //   ],
            // ),
            RadioListTile<int>(
              value: 2,
              groupValue: selectedLang,
              title: const Text(
                "မြန်မာ",
              ),
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setInt('language', 2);
                setState(() {
                  selectedLang = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
