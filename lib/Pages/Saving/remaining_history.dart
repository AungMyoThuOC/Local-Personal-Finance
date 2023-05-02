import 'package:flutter/material.dart';
import 'package:personal_finance/Database/create_database.dart';
import 'package:personal_finance/Database/remaining_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistRemain extends StatefulWidget {
  HistRemain({
    Key? key,
    required this.remaining,
    required this.autoID,
  }) : super(key: key);
  final RemainingMap remaining;
  String autoID;

  @override
  State<HistRemain> createState() => _HistRemainState();
}

class _HistRemainState extends State<HistRemain> {
  final _db = CreateDatabase.instance;
  List getDataList = [];
  bool check = false;

  _getData() async {
    List data = await _db.getRecordsRem();
    getDataList = data;
    if (data.isEmpty) {
      check = true;
    }
    print(">>>>>>>>>>>getRemainingHist : $getDataList");
    setState(() {});
  }

  // saveIdInSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('remaining_id', widget.autoID);
  //   setState(() {

  //   });
  // }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 18,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 22),
                      child: Text(
                        "${widget.remaining.record_remaining}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: getDataList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          right: 16,
                          left: 16,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _db.deleteRecordRem(
                                getDataList[index]["AutoID"],
                              );
                            });
                          },
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
